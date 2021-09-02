#include <iostream>

using namespace std;

class MyClass {
private:
	unsigned char dummyB = 3;
	unsigned char dummyBB = 6;
	int dummyW = 8;

	int myAdd(void);
public:
	void dummyFunc(void) {
		myAdd(); //Used to get the name mangling of the function
	}
	
};

int MyClass::myAdd(void) {
	return dummyW + dummyW;
}

typedef  void (MyClass::*MyClassMemFunc) (void);

int main(int argc, char *argv[]) {
	MyClass myObj;
	
	// Take the address of the public method that
	// calls the private one
	MyClassMemFunc dummyFuncAddr = &MyClass::dummyFunc;

	// Use a char* to search byte by byte
	char *mem;

	// Copy the address of the public method
	// to the char address
	memcpy(&mem, &dummyFuncAddr, sizeof(int *));


	// jmp 0991880h
	// opcode: xxxxxxxxe9
	// It's a near relative jump so
	// only the two low bits are used
	// xxxx050be9

	// Treat it as a short address to access two bytes
	// +5 because relative jump instruction is 5 bytes long
	// Bytes 1 and 2 of relative jump containes the offset
	// of the jump from this point.
#ifdef _DEBUG 
	// In debugging mode the generated assembly for calling
	// a function first jumps to an offset that includes
	// a jump to the real address of the function

	mem += *(short *)(mem + 1) + 5;
#endif

	// Loop through machine code until find 'call' opcode
	// call 0201389h
	// opcode xxxxxxxxe8
	// Only two low bytes is used because it's small scale code
	// xxxxfa7ee8
	// and the rest are filled with 0xff
	// fffffa7ee8

	// When find e8, search if the two highest bytes
	// of the 5-byte command is 0xff, to be sure that
	// e8 is referring to an opcode an not just a number
	while (true) {
		if (*(++mem) == (char)0xe8) {
			// Instead of performing a signle byte comparison
			// perform a 2 byte comparison
			short highBytes = 0x0000;
#ifdef _DEBUG
			// In debugging mode the high bytes of the call opcode
			// if 0xffff instead of 0x0000
			highBytes = 0xffff;
#endif
			if (*(short *)(mem + 3) == highBytes) {
				break;
			}
		}
	}

	// Extract the address where the call will
	// be performed (same as before)
	mem += *(short *)(mem + 1) + 5;

#ifdef _DEBUG
	// Same as above, no jump offset

	// Extract the (function's) address of the jump
	mem += *(short *)(mem + 1) + 5;
#endif

	int(*privMethodAddr) (MyClass *);
	memcpy(&privMethodAddr, &mem, sizeof(int *));

#if defined(_M_IX86) // For GNU C replace with "i386" or "__i386__"
	// Workaround for x86 because generated assembly
	// mov address of myObj to eax instead of ecx
	// With this ordinary function call, the address
	// is pushed to ecx, which stays the same when
	// we call the function though it's address
	myObj.dummyFunc();
#endif
	

	cout << "Result is: " << privMethodAddr(&myObj);

	return 0;
}