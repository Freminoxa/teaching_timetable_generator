import 'package:flutter/material.dart';
import '../../theme/must_theme.dart';
import '../../config/app_constants.dart';
import '../../screens/admin/admin_dashboard.dart';
import '../../screens/lecturer/lecturer_dashboard.dart';
import '../../screens/student/student_dashboard.dart';
import '../../models/user.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Simulated login function (will be replaced with actual authentication)
  Future<User?> _login(String email, String password) async {
    // For demo purposes - hardcoded users
    // In a real app, this would call an authentication service
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Lecturers from the PDF document with unique login credentials
if (email == 'admin@must.ac.ke' && password == 'admin123') {
  return User(
    id: 1, 
    name: 'Admin User', 
    email: email, 
    role: UserRole.admin
  );
} else if (email == 'w.karimi@must.ac.ke' && password == 'karimi2025') {
  return User(
    id: 2, 
    name: 'W. KARIMI', 
    email: email, 
    role: UserRole.lecturer,
    units: ['SSA 3120']
  );
} else if (email == 'd.kitaria@must.ac.ke' && password == 'kitaria2025') {
  return User(
    id: 3, 
    name: 'D. KITARIA', 
    email: email, 
    role: UserRole.lecturer,
    units: ['CIT 3150', 'CCS 3251']
  );
} else if (email == 's.mageto@must.ac.ke' && password == 'mageto2025') {
  return User(
    id: 4, 
    name: 'S. MAGETO', 
    email: email, 
    role: UserRole.lecturer,
    units: ['CIT 3154', 'CIT 3153', 'CIT 3157']
  );
} else if (email == 'a.irungu@must.ac.ke' && password == 'irungu2025') {
  return User(
    id: 5, 
    name: 'A. IRUNGU', 
    email: email, 
    role: UserRole.lecturer,
    units: ['CIT 3153', 'CCS 3255', 'CDS 3253', 'CDS 3353', 'CDS 3350', 'CDS 3452']
  );
} else if (email == 'm.asunta@must.ac.ke' && password == 'asunta2025') {
  return User(
    id: 6, 
    name: 'M. ASUNTA', 
    email: email, 
    role: UserRole.lecturer,
    units: ['CCU 3150', 'CIT 3152']
  );
} else if (email == 'k.murungi@must.ac.ke' && password == 'murungi2025') {
  return User(
    id: 7, 
    name: 'K. MURUNGI', 
    email: email, 
    role: UserRole.lecturer,
    units: ['SMC 3212']
  );
} else if (email == 'j.kithinji@must.ac.ke' && password == 'kithinji2025') {
  return User(
    id: 8, 
    name: 'DR. J. KITHINJI', 
    email: email, 
    role: UserRole.lecturer,
    units: ['CDS 3253', 'CCF 3350', 'CCF 3450']
  );
} else if (email == 'p.njuguna@must.ac.ke' && password == 'njuguna2025') {
  return User(
    id: 9, 
    name: 'P. NJUGUNA', 
    email: email, 
    role: UserRole.lecturer,
    units: ['CDS 3251', 'CCS 3351', 'CDS 3402']
  );
} else if (email == 'j.mwiti@must.ac.ke' && password == 'mwiti2025') {
  return User(
    id: 10, 
    name: 'J. MWITI', 
    email: email, 
    role: UserRole.lecturer,
    units: ['CCS 3303', 'CCS 3454', 'CCS 3202']
  );
} else if (email == 'g.gakii@must.ac.ke' && password == 'gakii2025') {
  return User(
    id: 11, 
    name: 'DR. G. GAKII', 
    email: email, 
    role: UserRole.lecturer,
    units: ['SMA 3303', 'SMA 3112', 'CDS 3252']
  );
} else if (email == 'd.kalui@must.ac.ke' && password == 'kalui2025') {
  return User(
    id: 12, 
    name: 'D. KALUI', 
    email: email, 
    role: UserRole.lecturer,
    units: ['CIT 3152', 'CIT 3153']
  );
} else if (email == 'j.mutembei@must.ac.ke' && password == 'mutembei2025') {
  return User(
    id: 13, 
    name: 'DR. J MUTEMBEI', 
    email: email, 
    role: UserRole.lecturer,
    units: ['SMA 3301', 'CIT 3350']
  );
} else if (email == 'c.chepkoech@must.ac.ke' && password == 'chepkoech2025') {
  return User(
    id: 14, 
    name: 'C. CHEPKOECH', 
    email: email, 
    role: UserRole.lecturer,
    units: ['SMS 3450']
  );
} else if (email == 'a.orto@must.ac.ke' && password == 'orto2025') {
  return User(
    id: 15, 
    name: 'A. ORTO', 
    email: email, 
    role: UserRole.lecturer,
    units: ['CD 3450', 'CCF 3451', 'CDS 3402']
  );
} else if (email == 'dr.mwadulo@must.ac.ke' && password == 'mwadulo2025') {
  return User(
    id: 16,
    name: 'DR. MWADULO',
    email: email,
    role: UserRole.lecturer,
    units: ['CIT 3451', 'CIT 3350', 'CCS 3353']
  );
} else if (email == 'j.jenu@must.ac.ke' && password == 'jenu2025') {
  return User(
    id: 17,
    name: 'J. JENU',
    email: email,
    role: UserRole.lecturer,
    units: ['CIT 3350', 'CCS 3451', 'CCS 3355']
  );
} else if (email == 'francis@must.ac.ke' && password == 'francis123') {
  return User(
    id: 100,
    name: 'Sample Student', 
    email: email, 
    role: UserRole.student,
    programCode: 'BCS',
    programYear: 3,
    programSemester: 1
  );
}
    return null;
  }

  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final user = await _login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null) {
          // Navigate based on user role
          if (!mounted) return;
          
          if (user.isAdmin) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => AdminDashboard(user: user)),
            );
          } else if (user.isLecturer) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LecturerDashboard(user: user)),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => StudentDashboard(user: user)),
            );
          }
        } else {
          setState(() {
            _errorMessage = 'Invalid email or password. Please try again.';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again later.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and University Name
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 100,
                        height: 100,
                        // Fallback color if image isn't available
                        color: MustTheme.primaryGreen,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.school,
                          size: 64,
                          color: MustTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    AppConstants.universityName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MustTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.schoolName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Timetable Generator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Login Form
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                prefixIcon: Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleLogin(),
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.red.shade700, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text('Sign In'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: _isLoading ? null : _handleLogin,
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                                  );
                                },
                                child: const Text('Forgot Password?'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    '© ${DateTime.now().year} ${AppConstants.universityName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}