	.globl isPrimeAssembly
isPrimeAssembly:
	//your code for iterating through arrays here
	//base addresses of arrays in X0 - X2, length in X3
	nop

	ADD X10, XZR, XZR			// Initialize i to 0, used in primeIterator to go through a[]
	ADD X11, XZR, XZR			// Initialize j to 0, used to index the prime array
	ADD X12, XZR, XZR			// Initialize k to 0, used to index the composite array

	// This loop loads and iterates through a[i] and send it to isPrime to check if it is
	Loop:
		SUB  X13, X10, X3		// Use temp X13 to check if counter is equal to length. If so, branch.

		CBZ X13, Exit			// If temp equal, branch

		LSL  X13,  X10, #3		// Left Shift i by 3 bits and store in temp X13
		ADD  X13,  X0,  X13		// Create base address for load in a[]
		LDUR X13, [X13, #0]		// Load content for offset 0 to be stored in either prime[] or composite[]
		ADD  X10,  X10, #1		// Increment i by 1 before branching

		b isPrime				// Branch to isPrime to check if a[i] is prime

	// If prime is found, add it to prime array
	Prime:
		LSL  X20,  X11, #3		// Left Shift j by 3 bits and store in X20
		ADD  X20,  X1,  X20		// Create base address to store in prime[j]
		STUR X13, [X20, #0]		// Store value of temp X13 in X20
		ADD  X11,  X11, #1		// Increment j for next prime

		b Loop					// Go back to the loop for the next value

	// If composite is found, add it to composite array
	Composite:
		LSL  X21,  X12, #3		// Left Shift k by 3 bits and store in X21
		ADD  X21,  X2,  X21		// Create base address to store in composite[k]
		STUR X13, [X21, #0]		// Store value of temp X13 in X21
		ADD  X12,  X12, #1		// Increment k for next composite

		b Loop					// Go back to the loop for the next value

	// Exit
	Exit:
		br X30					// Once a[i] is done going through, return x30 and exit


// Check if given value a[i] is prime or composite, and branch appropriately
isPrime:
	//Your code for detecting a prime number here
	ADD X14, XZR, #2			// Initialize i counter l, in isPrime. Used to iterate potential divisors of a[i]. set to 2, the first possible divisor.
	LSR X15, X13, #1			// Load a[i]/2 into temp X15. Used to to stop loop.

	// Loop through potential divisors of a[i]. If divided without remainder, its composite, if not, run until it is found prime
	checkDivisor:
		SUB X16, X15, X14		// see if l is less than n/2, which means there is no more possible divisors of a[i]

		CBZ X16, Prime			// branch to prime and add to prime[] if no more possible divisors of a[i]

		UDIV X17, X13, X14		// Floor Division, using temp X17 to check how many time l goes into a[i]
		MUL  X17, X17, X14		// Multiply l by X17 to check if it is equal to the original dividend
		SUB  X17, X13, X17		// Subtract divident by floor to find remainder of a[i]/l

		CBZ X17, Composite		// if l divides a[i] without remainder, a[i] is composite. therefore, branch

		ADD  X14, X14, #1		// Increment l by 1 to check next potential divisor

		b checkDivisor			// Loop back
