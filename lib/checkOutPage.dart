import 'package:check_out/SuccessFullPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage>
    with TickerProviderStateMixin {
  bool _showCardDetails = false;
  int _currentState = 0;
  bool _showRightMark = true;
  bool _isCardProcessing = false;
  bool allFieldsFilled = false;
  TextEditingController _textFieldController = TextEditingController();
  bool isTextFieldFilled = false;
  late PageController _pageController;
  PageController pageController = PageController(viewportFraction: 0.85);
  bool isCardContainerVisible = true;

  Color getArrowIconColor() {
    return _areAllFieldsFilled()
        ? Colors.green
        : Color.fromARGB(255, 168, 166, 166);
  }

  late AnimationController _circleAnimationController;
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  ValueNotifier<bool> _showRightMarkNotifier = ValueNotifier<bool>(false);

  bool isAnimationStarted = false;

  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _securityCodeController = TextEditingController();
  TextEditingController _cardHolderController = TextEditingController();
  TextEditingController _expDateController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _controller1 =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _controller2 =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _controller3 =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    //  _controller1.forward();
    _controller1.addListener(() {
      print("Controller 1 Status: ${_controller1.status}");
      if (_controller1.status == AnimationStatus.completed) {
        _controller2.forward();
      }
    });

    _controller2.addListener(() {
      print("Controller 2 Status: ${_controller2.status}");
      if (_controller2.status == AnimationStatus.completed) {
        _controller3.forward();
      }
    });

    _controller3.addListener(() {
      print("Controller 3 Status: ${_controller3.status}");
      if (_controller3.status == AnimationStatus.completed) {
        setState(() {
          _showRightMark = true;
        });
        _showRightMarkNotifier.value =
            true; // Notify when the right mark is visible
      }
    });

    _textFieldController.addListener(() {
      setState(() {
        isTextFieldFilled = _textFieldController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _showRightMarkNotifier.dispose();
    super.dispose();
    _cardNumberController.dispose();
    _securityCodeController.dispose();
    _cardHolderController.dispose();
    _expDateController.dispose();
    _zipCodeController.dispose();
  }

  void _startAnimation() {
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
    _showRightMark =
        true; // Resetting the state to false before starting animations

    // Start the animations after resetting
    _controller1.forward().then((_) {
      _controller2.forward().then((_) {
        _controller3.forward().then((_) {
          setState(() {
            _showRightMark =
                true; // Set _showRightMark to true after all animations complete
          });
        });
      });
    });
  }

  void _onArrowTapped() {
    if (!_isCardProcessing) {
      // Assuming _isCardProcessing indicates whether the animation is ongoing.
      _startAnimation(); // Start the animation sequence
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Check Out',
            style: TextStyle(color: Colors.black, fontSize: 25.0),
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35, top: 25),
            child: _buildCardBasedOnState(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35, top: 25),
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 164, 162, 162),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: const Color.fromARGB(221, 194, 193, 193),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 30, top: 17),
                    child: Text(
                      "Order Details",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  _buildOrderDetail("Bonsai Points", "\$ 38.99"),
                  const SizedBox(height: 6),
                  _buildOrderDetail("Plant Fertilizer", "\$ 19.99"),
                  const SizedBox(height: 6),
                  _buildOrderDetail("Plant Soil", "\$ 12.99"),
                  const SizedBox(height: 6),
                  const Divider(),
                  const SizedBox(height: 6),
                  _buildAmountDetails("SubTotal", "\$71.97"),
                  _buildAmountDetails("Shipping", "\$9.99"),
                  _buildAmountDetails("Tax", "\$8.64"),
                  const Divider(),
                  _buildOrderDetail("Total", "\$90.60"),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _showRightMarkNotifier,
            builder: (context, showRightMark, child) {
              return showRightMark
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                Duration(milliseconds: 200), // adjust as needed
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SuccessfullPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(
                                      0.0, 1.0), // start from bottom-right
                                  end: Offset
                                      .zero, // end at its original position (top-left)
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 80, right: 80, top: 25),
                        child: _buildContainer(showRightMark),
                      ),
                    )
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 80, right: 80, top: 25),
                      child: _buildContainer(showRightMark),
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(bool showRightMark) {
    return GestureDetector(
      onTap: showRightMark
          ? null
          : () {
              // Your onTap logic here when the container is enabled
              print('Pay It tapped!');
            },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: showRightMark ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: showRightMark
                  ? Colors.green
                  : Colors.red), // Adjust border color if needed
        ),
        child: Center(
          child: Text(
            'Pay It',
            style: TextStyle(
              color: Colors
                  .white, // Keeping it white for readability; adjust as needed
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBasedOnState() {
    switch (_currentState) {
      case 0:
        return _buildAddNewCard();
      case 1:
        return _buildDetailedCard();
      case 2:
        return _buildProcessingCard();
      default:
        return Container(); // Return an empty container or handle the default case as per your requirement
    }
  }

  Widget _buildOrderDetail(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 40, top: 10),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountDetails(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 90, right: 30, top: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 65, 64, 64),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 40, top: 10),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 65, 64, 64),
            ),
          ),
        ),
      ],
    );
  }

  bool _isRightIconVisible = false;
  Widget _buildAddNewCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isRightIconVisible = true;
          _showCardDetails = true;
          _currentState = 1;
        });
      },
      child: (_showCardDetails && _isRightIconVisible)
          ? _buildDetailedCard()
          : _buildAddNewCardContainer(),
    );
  }

  bool _areAllFieldsFilled() {
    return _cardNumberController.text.isNotEmpty &&
        _securityCodeController.text.isNotEmpty &&
        _cardHolderController.text.isNotEmpty &&
        _expDateController.text.isNotEmpty &&
        _zipCodeController.text.isNotEmpty;
  }

  Widget _buildDetailedCard() {
    Color boxColor = allFieldsFilled
        ? Colors.green
        : const Color.fromARGB(255, 168, 166, 166);
    return Column(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >= 332 && !_showRightMark) {
              setState(() {
                _showRightMark = true;
              });
            } else if (scrollInfo.metrics.pixels < 332 && _showRightMark) {
              setState(() {
                _showRightMark = false;
              });
            }
            return true;
          },
          child: SingleChildScrollView(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: 330), // set your maximum width
                  child: _buildCardContainer(),
                ),
                SizedBox(width: 2),
                if (!_showRightMark)
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: 330), // set your maximum width
                    child: _buildAddNewCardContainer(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer() {
    // Your card container logic remains unchanged.
    return Padding(
      padding:
          const EdgeInsets.only(left: 0.0, right: 0.0, top: 8.0, bottom: 8.0),
      child: Container(
        height: 200,
        width: 350,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 44, 60, 26),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCreditCardDetails("Credit Card Number"),
                    _buildCreditCardDetails("Security Code"),
                  ],
                ),
                Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 230,
                      child: _buildTextField(0),
                    ),
                    Container(
                      width: 100,
                      child: _buildTextField(1),
                    ),
                  ],
                ),
                _buildCreditCardDetails("Card Holder"),
                Padding(
                  padding: const EdgeInsets.only(right: 95),
                  child: _buildTextField(2),
                ),
                Row(
                  children: [
                    _buildCreditCardDetails("Exp. Date"),
                    _buildCreditCardDetails("Zip Code"),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 65,
                        top: 45,
                      ),
                      child: Text(
                        "VISA",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      child: _buildTextField(3),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 100,
                      child: _buildTextField(4),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 80,
              right: -10,
              child: SizedBox(
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    if (!_isCardProcessing && _areAllFieldsFilled()) {
                      _startAnimation();
                      print("Arrow icon tapped");
                      setState(() {
                        _showRightMark = true;
                        _currentState = 2;
                      });
                    }
                  },
                  // : null,
                  child: _isCardProcessing && !_showRightMark
                      ? null
                      : Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: getArrowIconColor(),
                            borderRadius: BorderRadius.circular(40),
                          ),

                          // decoration: BoxDecoration(
                          //   color: _areAllFieldsFilled()
                          //       ? Colors.green
                          //       : Color.fromARGB(255, 168, 166, 166),
                          //   borderRadius: BorderRadius.circular(40),
                          // ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCardContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        width: 335,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 251, 229, 228),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: const Color.fromARGB(255, 168, 20, 10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color.fromARGB(255, 168, 20, 10),
              radius: 29,
              child: Icon(
                Icons.add,
                size: 35,
              ),
            ),
            SizedBox(height: 9),
            Text(
              "Add a new Card",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingCard() {
    if (_showRightMark) {
      _isCardProcessing = true;

      // If _showRightMark becomes true, wait for 2 seconds and then transition to the detailed card view.
      Future.delayed(const Duration(seconds: 6), () {
        setState(() {
          _showRightMark = false;
          _currentState = 1; // This will show the detailed card view.
        });
      });
    }
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 44, 60, 26),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: const Color.fromARGB(255, 44, 60, 26),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // _buildRightMarkIfNeeded(_controller3),
          // if (!_showRightMark) _buildRightMark(),
          if (_controller3.status == AnimationStatus.completed)
            _buildRightMark(),
          if (_controller3.status != AnimationStatus.completed)
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
          SizedBox(height: 9),
          Text(
            _controller3.status == AnimationStatus.completed
                ? "Your card is added"
                : "Verifying your card",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          if (!_showRightMark) // Display the right mark if _showRightMark is true
            _buildRightMark(),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircle(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // _checkAnimationCompletion();
        if (controller.status == AnimationStatus.completed) {
          // If the animation for the 3rd circle is completed, set _showRightMark to true
          if (controller == _controller3) {
            _showRightMark = true;
          }
        }
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: controller.value == 1 ? Colors.red : Colors.white,
            border: Border.all(color: Colors.white, width: 2),
          ),
        );
      },
      child: _buildRightMarkIfNeeded(controller),
    );
  }

  Widget _buildRightMarkIfNeeded(AnimationController controller) {
    if (controller == _controller3 &&
        controller.status == AnimationStatus.completed) {
      return _buildRightMark();
    } else {
      return SizedBox
          .shrink(); // Return an empty widget if the conditions are not met
    }
  }

  Widget _buildRightMark() {
    return Icon(
      Icons.check,
      color: Colors.green,
      size: 50.0,
    );
  }

  Widget _buildCreditCardDetails(String details) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Text(
        details,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField(int index) {
    TextEditingController _controller = TextEditingController();
    List<TextInputFormatter> inputFormatters = [];

    _controller.addListener(() {
      setState(() {
        TextEditingController _controller = TextEditingController();

        _controller.addListener(() {
          setState(() {
            // Check if all text fields have content
            allFieldsFilled = _cardNumberController.text.isNotEmpty &&
                _securityCodeController.text.isNotEmpty &&
                _cardHolderController.text.isNotEmpty &&
                _expDateController.text.isNotEmpty &&
                _zipCodeController.text.isNotEmpty;
            print("All fields filled: $allFieldsFilled");
          });
        });
      }); // Trigger a UI rebuild
    });
    switch (index) {
      case 0:
        _controller = _cardNumberController;
        //  inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        break;
      case 1:
        _controller = _securityCodeController;
        inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        break;
      case 2:
        _controller = _cardHolderController;
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
        ];
        break;
      case 3:
        _controller = _expDateController;
        //   inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        break;
      case 4:
        _controller = _zipCodeController;
        inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        break;
      default:
        _controller = TextEditingController();

        break;
    }

    _controller.addListener(() {
      setState(() {}); // Rebuild the widget when text changes
    });

    if (index == 0) {
      // Apply the logic only for the first TextField
      _controller.addListener(() {
        if (_controller.text.length == 4 ||
            _controller.text.length == 9 ||
            _controller.text.length == 14) {
          _controller.text += ' '; // Add a space after 4 characters
          _controller.selection = TextSelection.collapsed(
              offset: _controller.text.length); // Move the cursor to the end
        }
      });
    }
    // If index == 0, apply the 19-digit limit
    if (index == 0) {
      _controller.addListener(() {
        if (_controller.text.length > 19) {
          // Trim the text to 19 characters if it exceeds the limit
          _controller.text = _controller.text.substring(0, 19);
          _controller.selection = TextSelection.collapsed(
              offset: _controller.text.length); // Move cursor to the end
        }
      });
    }

    if (index == 1) {
      _controller.addListener(() {
        if (_controller.text.length > 3) {
          // Truncate the text to ensure it's no longer than 5 characters
          _controller.text = _controller.text.substring(0, 3);
          _controller.selection = TextSelection.collapsed(
              offset: _controller.text.length); // Move cursor to the end
        }
      });
    }

    if (index == 2) {
      _controller.addListener(() {
        if (_controller.text.length > 15) {
          // Truncate the text to ensure it's no longer than 5 characters
          _controller.text = _controller.text.substring(0, 15);
          _controller.selection = TextSelection.collapsed(
              offset: _controller.text.length); // Move cursor to the end
        }
      });
    }

    if (index == 3) {
      _controller.addListener(() {
        if (_controller.text.length == 2) {
          _controller.text += '/';
          _controller.selection =
              TextSelection.collapsed(offset: _controller.text.length);
        }
      });
    }

    if (index == 3) {
      _controller.addListener(() {
        // Apply the 5-character limit including the '/'
        if (_controller.text.length > 5) {
          // Truncate the text to ensure it's no longer than 5 characters
          _controller.text = _controller.text.substring(0, 5);
          _controller.selection = TextSelection.collapsed(
              offset: _controller.text.length); // Move cursor to the end
        }
      });
    }

    if (index == 4) {
      _controller.addListener(() {
        // Apply the 5-character limit including the '/'
        if (_controller.text.length > 6) {
          // Truncate the text to ensure it's no longer than 5 characters
          _controller.text = _controller.text.substring(0, 6);
          _controller.selection = TextSelection.collapsed(
              offset: _controller.text.length); // Move cursor to the end
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 5,
        child: TextField(
          controller: _controller,
          enabled: !_isCardProcessing,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          inputFormatters: inputFormatters,
        ),
      ),
    );
  }
}
