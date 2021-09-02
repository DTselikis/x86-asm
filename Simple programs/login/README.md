## Login written in assembly
### login_custom
Implemented with custrom functions for I/O handling.
### login_vc
Uses printf and scanf from msvcrt.dll for I/O handling.
### login_vc_mask
Same as login_vc but uses and _getch and _putch from msvcrt.dll for I/0 handling. By using those functions we are able to replace the password with '*' for privacy.