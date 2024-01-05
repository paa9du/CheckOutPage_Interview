import 'package:flutter/material.dart';

class SuccessfullPage extends StatefulWidget {
  @override
  State<SuccessfullPage> createState() => _SuccessfullPageState();
}

class _SuccessfullPageState extends State<SuccessfullPage>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  bool _showRightMark = false;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _controller3 = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _controller1.forward().then((_) {
      _controller2.forward().then((_) {
        _controller3.forward().then((_) {
          setState(() {
            _showRightMark = true;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 165, 70, 63),
      body: Center(
        child: _showRightMark
            ? _buildRightMark()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Processing",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedCircle(_controller1),
                      SizedBox(width: 10),
                      _buildAnimatedCircle(_controller2),
                      SizedBox(width: 10),
                      _buildAnimatedCircle(_controller3),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAnimatedCircle(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: controller.status == AnimationStatus.completed
                ? Colors.red
                : Colors.white,
            border: Border.all(color: Colors.white, width: 2),
          ),
        );
      },
    );
  }

  Widget _buildRightMark() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check,
          color: Colors.green,
          size: 50.0,
        ),
        SizedBox(height: 10),
        Text(
          "Completed",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ],
    );
  }
}
