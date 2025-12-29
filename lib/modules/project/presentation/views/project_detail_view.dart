import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';

class ProjectDetailView extends StatefulWidget {
  final String id;
  final String title;
  final String? imagePath;

  const ProjectDetailView({
    super.key,
    required this.id,
    required this.title,
    this.imagePath,
  });

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

enum InteractionMode { none, addPoint, addPolygon, addLine }

enum ChecklistStatus { none, pass, fail, warning }

class _ProjectDetailViewState extends State<ProjectDetailView> {
  final TransformationController _transformationController =
      TransformationController();

  // Global ID counter
  int _nextId = 1;

  // Independent lists
  final List<MapPoint> _pointMarkers = [];
  final List<MapPolygon> _polygons = [];
  final List<MapLine> _lines = [];

  // Checklist Data: { "ObjectId" : { "Criteria" : StatusInt } }
  // StatusInt: 0=none, 1=pass, 2=fail, 3=warning
  Map<String, Map<String, int>> _checklistData = {};

  final List<String> _criteriaList = [
    "Elevasi sesuai (terutama area basah)",
    "Diameter besi",
    "Susunan formasi dan dimensi",
    "Kaitan sengkang: ditekuk 135°, panjang minimal 5cm",
    "Jarak sengkang",
  ];

  InteractionMode _currentMode = InteractionMode.addPoint;

  // Scaffold Key for Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Force landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _loadData();
  }

  Future<void> _saveData() async {
    final Map<String, dynamic> data = {
      'nextId': _nextId,
      'points': _pointMarkers
          .map((p) => {'id': p.id, 'x': p.offset.dx, 'y': p.offset.dy})
          .toList(),
      'polygons': _polygons.where((p) => p.offsets.isNotEmpty).map((poly) {
        return {
          'id': poly.id,
          'points': poly.offsets.map((o) => {'x': o.dx, 'y': o.dy}).toList(),
        };
      }).toList(),
      'lines': _lines.where((l) => l.offsets.isNotEmpty).map((line) {
        return {
          'id': line.id,
          'points': line.offsets.map((o) => {'x': o.dx, 'y': o.dy}).toList(),
        };
      }).toList(),
      'checklist': _checklistData,
    };

    final String jsonString = jsonEncode(data);
    final prefs = await SharedPreferences.getInstance();
    // Use title as part of key to separate projects (simple unique key for now)
    await prefs.setString('project_data_${widget.id}', jsonString);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Project saved locally!"),
          backgroundColor: AppColors.secondary,
        ),
      );
    }
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('project_data_${widget.id}');

    if (jsonString == null) return;

    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      setState(() {
        _nextId = data['nextId'] ?? 1;

        _pointMarkers.clear();
        if (data['points'] != null) {
          for (var p in data['points']) {
            _pointMarkers.add(
              MapPoint(id: p['id'], offset: Offset(p['x'], p['y'])),
            );
          }
        }

        _polygons.clear();
        if (data['polygons'] != null) {
          for (var poly in data['polygons']) {
            List<Offset> offsets = [];
            for (var o in poly['points']) {
              offsets.add(Offset(o['x'], o['y']));
            }
            _polygons.add(MapPolygon(id: poly['id'], offsets: offsets));
          }
        }
        // Ensure at least one empty polygon container exists if needed, or handle in add
        if (_polygons.isEmpty) {
          _polygons.add(MapPolygon(id: _nextId++, offsets: []));
        }

        _lines.clear();
        if (data['lines'] != null) {
          for (var line in data['lines']) {
            List<Offset> offsets = [];
            for (var o in line['points']) {
              offsets.add(Offset(o['x'], o['y']));
            }
            _lines.add(MapLine(id: line['id'], offsets: offsets));
          }
        }

        _checklistData = {};
        if (data['checklist'] != null) {
          Map<String, dynamic> checklistMap = data['checklist'];
          checklistMap.forEach((key, value) {
            _checklistData[key] = Map<String, int>.from(value);
          });
        }
      });
    } catch (e) {
      debugPrint("Error loading project data: $e");
    }
  }

  @override
  void dispose() {
    // Reset to portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      final double s =
          _transformationController.value.getMaxScaleOnAxis() * 1.5;
      _transformationController.value = Matrix4.diagonal3Values(s, s, s);
    });
  }

  void _zoomOut() {
    setState(() {
      final double s =
          _transformationController.value.getMaxScaleOnAxis() / 1.5;
      _transformationController.value = Matrix4.diagonal3Values(s, s, s);
    });
  }

  double get _currentScale =>
      _transformationController.value.getMaxScaleOnAxis();

  void _showMarkerDetails(Offset offset, int index, {bool isPolygon = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isPolygon ? "Poly Vertex" : "Marker Output #$index"),
          content: Text(
            "Coordinates:\nX: ${offset.dx.toStringAsFixed(2)}\nY: ${offset.dy.toStringAsFixed(2)}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _addNewPolygon() {
    if (_polygons.last.offsets.isNotEmpty) {
      setState(() {
        _polygons.add(MapPolygon(id: _nextId++, offsets: []));
      });
    }
  }

  void _addNewLine() {
    if (_lines.isNotEmpty && _lines.last.offsets.isEmpty) return;
    setState(() {
      _lines.add(MapLine(id: _nextId++, offsets: []));
    });
  }

  Offset _computeCentroid(List<Offset> points) {
    if (points.isEmpty) return Offset.zero;
    double dx = 0;
    double dy = 0;
    for (var point in points) {
      dx += point.dx;
      dy += point.dy;
    }
    return Offset(dx / points.length, dy / points.length);
  }

  void _resetCanvas() {
    setState(() {
      _pointMarkers.clear();
      _polygons.clear();
      _lines.clear();
      _nextId = 1;
      _polygons.add(MapPolygon(id: _nextId++, offsets: []));
      _currentMode = InteractionMode.addPoint;
      _checklistData.clear();
    });
  }

  void _toggleChecklistStatus(String objId, String criteria, int status) {
    setState(() {
      if (_checklistData[objId] == null) {
        _checklistData[objId] = {};
      }

      // Toggle logic: if clicking same status, set to none (0)
      if (_checklistData[objId]![criteria] == status) {
        _checklistData[objId]![criteria] = 0;
      } else {
        _checklistData[objId]![criteria] = status;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      endDrawer: _buildChecklistDrawer(),
      body: Stack(
        children: [
          // 1. Interactive Map Layer
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.all(
                500.0,
              ), // Allow panning freely
              minScale: 0.1,
              maxScale: 5.0,
              constrained: false,
              child: GestureDetector(
                onTapUp: (details) {
                  setState(() {
                    if (_currentMode == InteractionMode.addPoint) {
                      _pointMarkers.add(
                        MapPoint(id: _nextId++, offset: details.localPosition),
                      );
                    } else if (_currentMode == InteractionMode.addPolygon) {
                      if (_polygons.isEmpty) {
                        _polygons.add(MapPolygon(id: _nextId++, offsets: []));
                      }
                      _polygons.last.offsets.add(details.localPosition);
                    } else if (_currentMode == InteractionMode.addLine) {
                      if (_lines.isEmpty) {
                        _lines.add(MapLine(id: _nextId++, offsets: []));
                      }
                      _lines.last.offsets.add(details.localPosition);
                    }
                  });
                },
                child: Stack(
                  children: [
                    Image.asset(
                      widget.imagePath ??
                          "assets/WhatsApp Image 2025-12-22 at 14.18.20.jpeg",
                    ),
                    Positioned.fill(
                      child: CustomPaint(painter: PolygonPainter(_polygons)),
                    ),
                    Positioned.fill(
                      child: CustomPaint(painter: LinePainter(_lines)),
                    ),
                    // ... Render Logic (Same as before, simplified for brevity in this full replace)
                    ..._buildInteractiveElements(),
                  ],
                ),
              ),
            ),
          ),

          // 2. Floating Top Bar
          Positioned(top: 0, left: 0, right: 0, child: _buildTopBar()),

          // 3. Floating Bottom Toolbar
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Center(child: _buildToolbar()),
          ),

          // 4. Zoom Controls (Right Side)
          Positioned(
            right: 24,
            bottom: 100,
            child: Column(
              children: [
                _buildZoomButton(Icons.add, _zoomIn),
                const SizedBox(height: 12),
                _buildZoomButton(Icons.remove, _zoomOut),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInteractiveElements() {
    List<Widget> elements = [];

    // Line Labels
    for (var line in _lines.where((l) => l.offsets.isNotEmpty)) {
      Offset centroid = _computeCentroid(line.offsets);
      elements.add(
        Positioned(
          left: centroid.dx - 10,
          top: centroid.dy - 10,
          child: _buildDraggableLabel(
            line.id.toString(),
            AppColors.secondary, // Teal for lines
            (details) {
              setState(() {
                for (int i = 0; i < line.offsets.length; i++) {
                  line.offsets[i] += details.delta / _currentScale;
                }
              });
            },
          ),
        ),
      );
    }

    // Polygon Labels
    for (var poly in _polygons.where((p) => p.offsets.isNotEmpty)) {
      Offset centroid = _computeCentroid(poly.offsets);
      elements.add(
        Positioned(
          left: centroid.dx - 10,
          top: centroid.dy - 10,
          child: _buildDraggableLabel(
            poly.id.toString(),
            AppColors.primary, // Orange for polygons
            (details) {
              setState(() {
                for (int i = 0; i < poly.offsets.length; i++) {
                  poly.offsets[i] += details.delta / _currentScale;
                }
              });
            },
          ),
        ),
      );
    }

    // Polygon Vertices
    for (var poly in _polygons) {
      for (int i = 0; i < poly.offsets.length; i++) {
        elements.add(
          Positioned(
            left: poly.offsets[i].dx - 6, // Center anchor
            top: poly.offsets[i].dy - 6,
            child: _buildVertexHandle(
              AppColors.primary,
              (details) {
                setState(() {
                  poly.offsets[i] += details.delta / _currentScale;
                });
              },
              () => _showMarkerDetails(poly.offsets[i], 0, isPolygon: true),
            ),
          ),
        );
      }
    }

    // Line Vertices
    for (var line in _lines) {
      for (int i = 0; i < line.offsets.length; i++) {
        elements.add(
          Positioned(
            left: line.offsets[i].dx - 6,
            top: line.offsets[i].dy - 6,
            child: _buildVertexHandle(AppColors.secondary, (details) {
              setState(() {
                line.offsets[i] += details.delta / _currentScale;
              });
            }, () => _showMarkerDetails(line.offsets[i], 0)),
          ),
        );
      }
    }

    // Point Markers
    for (int i = 0; i < _pointMarkers.length; i++) {
      var point = _pointMarkers[i];
      elements.add(
        Positioned(
          left: point.offset.dx - 14, // Center the 28px circle
          top: point.offset.dy - 14,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _pointMarkers[i] = MapPoint(
                  id: point.id,
                  offset: point.offset + details.delta / _currentScale,
                );
              });
            },
            onTap: () => _showMarkerDetails(point.offset, point.id),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "${point.id}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return elements;
  }

  Widget _buildDraggableLabel(
    String label,
    Color color,
    Function(DragUpdateDetails) onDrag,
  ) {
    return GestureDetector(
      onPanUpdate: onDrag,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildVertexHandle(
    Color color,
    Function(DragUpdateDetails) onDrag,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onPanUpdate: onDrag,
      onTap: onTap,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _buildGlassIconButton(
              Icons.arrow_back_ios_new_rounded,
              () => Navigator.pop(context),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            // Create Checklist Button
            _buildGlassIconButton(
              Icons.fact_check_outlined,
              () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
            const SizedBox(width: 8),
            _buildGlassIconButton(Icons.save_alt_rounded, _saveData),
          ],
        ),
      ),
    );
  }

  // CHECKLIST DRAWER IMPLEMENTATION
  Widget _buildChecklistDrawer() {
    // Collect all object IDs (Points, Polygons, Lines)
    List<String> objectIds = [];
    objectIds.addAll(_pointMarkers.map((e) => e.id.toString()));
    objectIds.addAll(
      _polygons.where((p) => p.offsets.isNotEmpty).map((e) => e.id.toString()),
    );
    objectIds.addAll(
      _lines.where((l) => l.offsets.isNotEmpty).map((e) => e.id.toString()),
    );

    // Sort logic
    objectIds.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8, // Take up 80% width
      backgroundColor: const Color(0xFFE0E0E0), // Light gray background
      child: Column(
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary,
            width: double.infinity,
            child: SafeArea(
              bottom: false,
              child: Text(
                "Inspection Checklist",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FIXED LEFT COLUMN (Criteria)
                  SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        _buildHeaderCell(
                          "Checklist",
                          width: 250,
                          alignLeft: true,
                        ),
                        ...List.generate(_criteriaList.length, (index) {
                          return _buildCriteriaCell(
                            _criteriaList[index],
                            index % 2 == 0
                                ? Colors.grey[200]!
                                : Colors.grey[300]!,
                          );
                        }),
                      ],
                    ),
                  ),

                  // SCROLLABLE RIGHT AREA (Data)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row (Object IDs)
                          Row(
                            children: objectIds.map((objId) {
                              return _buildHeaderCell(objId);
                            }).toList(),
                          ),
                          // Data Rows
                          ...List.generate(_criteriaList.length, (index) {
                            String criteria = _criteriaList[index];
                            Color bgColor = index % 2 == 0
                                ? Colors.grey[200]!
                                : Colors.grey[300]!;

                            return Row(
                              children: objectIds.map((objId) {
                                return Container(
                                  width: 160,
                                  height: 60,
                                  color: bgColor,
                                  child: _buildChecklistCell(objId, criteria),
                                );
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    String text, {
    double width = 160,
    bool alignLeft = false,
  }) {
    return Container(
      width: width,
      height: 50,
      alignment: alignLeft ? Alignment.centerLeft : Alignment.center,
      padding: alignLeft ? const EdgeInsets.symmetric(horizontal: 16) : null,
      color: Colors.grey[400],
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: alignLeft ? Colors.black87 : Colors.blue[900],
          fontSize: alignLeft ? 14 : 16,
        ),
      ),
    );
  }

  Widget _buildCriteriaCell(String text, Color color) {
    return Container(
      width: 250,
      height: 60,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: color,
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.blue[900]),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildChecklistCell(String objId, String criteria) {
    // Get current status: 0=none, 1=pass, 2=fail, 3=warn
    int currentStatus = _checklistData[objId]?[criteria] ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pass (Green)
        _buildStatusToggle(
          objId,
          criteria,
          1,
          currentStatus == 1,
          const Color(0xFF008000), // Dark Green
        ),
        // Fail (Red)
        _buildStatusToggle(
          objId,
          criteria,
          2,
          currentStatus == 2,
          const Color(0xFFD32F2F), // Red
        ),
        // Warning (Yellow)
        _buildStatusToggle(
          objId,
          criteria,
          3,
          currentStatus == 3,
          const Color(0xFFFBC02D), // Yellow
        ),
        // Camera Icon (Placeholder)
        Icon(Icons.camera_alt_outlined, size: 20, color: Colors.grey[600]),
      ],
    );
  }

  Widget _buildStatusToggle(
    String objId,
    String criteria,
    int statusValue,
    bool isActive,
    Color activeColor,
  ) {
    return GestureDetector(
      onTap: () => _toggleChecklistStatus(objId, criteria, statusValue),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          border: Border.all(
            color: isActive
                ? activeColor
                : Colors.brown[400]!, // Match schematic look
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(6), // Slightly rounded rect
        ),
      ),
    );
  }

  Widget _buildGlassIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white.withValues(alpha: 0.15),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return _buildGlassIconButton(icon, onTap);
  }

  Widget _buildToolbar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToolItem(
                Icons.location_on_outlined,
                InteractionMode.addPoint,
              ),
              const SizedBox(width: 8),
              _buildToolItem(
                Icons.polyline_outlined,
                InteractionMode.addPolygon,
              ),
              const SizedBox(width: 8),
              _buildToolItem(Icons.timeline_rounded, InteractionMode.addLine),
              const SizedBox(width: 16), // Separator
              Container(
                width: 1,
                height: 24,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 16),
              if (_currentMode == InteractionMode.addPolygon)
                _buildActionButton("New Poly", Icons.add, _addNewPolygon),
              if (_currentMode == InteractionMode.addLine)
                _buildActionButton("New Line", Icons.add, _addNewLine),
              if (_currentMode == InteractionMode.addPoint)
                const SizedBox(
                  width: 80,
                  child: Center(
                    child: Text(
                      "Tap map",
                      style: TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                  ),
                ),

              const SizedBox(width: 8),
              _buildToolItem(
                Icons.refresh_rounded,
                InteractionMode.none,
                onTap: _resetCanvas,
                isAction: true,
                color: AppColors.error,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolItem(
    IconData icon,
    InteractionMode mode, {
    VoidCallback? onTap,
    bool isAction = false,
    Color? color,
  }) {
    final bool isSelected = _currentMode == mode && !isAction;
    return GestureDetector(
      onTap:
          onTap ??
          () {
            setState(() => _currentMode = mode);
          },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (color?.withValues(alpha: 0.2) ?? Colors.transparent),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : (color ?? Colors.white70),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  final List<MapPolygon> polygons;

  PolygonPainter(this.polygons);

  @override
  void paint(Canvas canvas, Size size) {
    if (polygons.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.secondary
          .withValues(alpha: 0.3) // Teal fill
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var polygon in polygons) {
      if (polygon.offsets.isEmpty) continue;

      final path = Path();
      path.moveTo(
        polygon.offsets[0].dx + 5,
        polygon.offsets[0].dy + 5,
      ); // Offset for better touch alignment

      for (int i = 1; i < polygon.offsets.length; i++) {
        path.lineTo(polygon.offsets[i].dx + 5, polygon.offsets[i].dy + 5);
      }
      path.close();

      canvas.drawPath(path, paint);
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LinePainter extends CustomPainter {
  final List<MapLine> lines;

  LinePainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors
          .tertiary // Light blue lines
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    for (var line in lines) {
      if (line.offsets.length < 2) continue;

      final path = Path();
      path.moveTo(line.offsets[0].dx + 5, line.offsets[0].dy + 5);
      for (int i = 1; i < line.offsets.length; i++) {
        path.lineTo(line.offsets[i].dx + 5, line.offsets[i].dy + 5);
      }

      // Draw dashed line manually if needed, or solid for now
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MapPoint {
  final int id;
  final Offset offset;

  MapPoint({required this.id, required this.offset});
}

class MapPolygon {
  final int id;
  final List<Offset> offsets;

  MapPolygon({required this.id, required this.offsets});
}

class MapLine {
  final int id;
  final List<Offset> offsets;

  MapLine({required this.id, required this.offsets});
}
