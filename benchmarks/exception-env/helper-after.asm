
/tmp/fbjni-env-validation.sbf8z9/android-after/libfbjni.so:	file format elf64-littleaarch64

Disassembly of section .text:

0000000000018ca8 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv>:
   18ca8: d10143ff     	sub	sp, sp, #0x50
   18cac: a9027bfd     	stp	x29, x30, [sp, #0x20]
   18cb0: f9001bf5     	str	x21, [sp, #0x30]
   18cb4: a9044ff4     	stp	x20, x19, [sp, #0x40]
   18cb8: 910083fd     	add	x29, sp, #0x20
   18cbc: d53bd054     	mrs	x20, TPIDR_EL0
   18cc0: aa0003f3     	mov	x19, x0
   18cc4: f9401688     	ldr	x8, [x20, #0x28]
   18cc8: f81f83a8     	stur	x8, [x29, #-0x8]
   18ccc: f9400008     	ldr	x8, [x0]
   18cd0: f9439108     	ldr	x8, [x8, #0x720]
   18cd4: d63f0100     	blr	x8
   18cd8: 72001c1f     	tst	w0, #0xff
   18cdc: 54000141     	b.ne	0x18d04 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv+0x5c>
   18ce0: f9401688     	ldr	x8, [x20, #0x28]
   18ce4: f85f83a9     	ldur	x9, [x29, #-0x8]
   18ce8: eb09011f     	cmp	x8, x9
   18cec: 540008a1     	b.ne	0x18e00 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv+0x158>
   18cf0: a9444ff4     	ldp	x20, x19, [sp, #0x40]
   18cf4: f9401bf5     	ldr	x21, [sp, #0x30]
   18cf8: a9427bfd     	ldp	x29, x30, [sp, #0x20]
   18cfc: 910143ff     	add	sp, sp, #0x50
   18d00: d65f03c0     	ret
   18d04: f9400268     	ldr	x8, [x19]
   18d08: aa1303e0     	mov	x0, x19
   18d0c: f90003f4     	str	x20, [sp]
   18d10: f9403d08     	ldr	x8, [x8, #0x78]
   18d14: d63f0100     	blr	x8
   18d18: b5000240     	cbnz	x0, 0x18d60 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv+0xb8>
   18d1c: 52800200     	mov	w0, #0x10               // =16
   18d20: 940040ac     	bl	0x28fd0 <__cxa_allocate_exception@plt>
   18d24: aa0003f4     	mov	x20, x0
   18d28: d503201f     	nop
   18d2c: 50fb2421     	adr	x1, 0xf1b2 <syscall+0xf1b2>
   18d30: 940040b0     	bl	0x28ff0 <_ZNSt13runtime_errorC1EPKc@plt>
   18d34: f94003e8     	ldr	x8, [sp]
   18d38: f9401508     	ldr	x8, [x8, #0x28]
   18d3c: f85f83a9     	ldur	x9, [x29, #-0x8]
   18d40: eb09011f     	cmp	x8, x9
   18d44: 540005e1     	b.ne	0x18e00 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv+0x158>
   18d48: f0000081     	adrp	x1, 0x2b000 <_DYNAMIC+0x170>
   18d4c: f0000082     	adrp	x2, 0x2b000 <_DYNAMIC+0x170>
   18d50: aa1403e0     	mov	x0, x20
   18d54: f9403821     	ldr	x1, [x1, #0x70]
   18d58: f9403c42     	ldr	x2, [x2, #0x78]
   18d5c: 940040a9     	bl	0x29000 <__cxa_throw@plt>
   18d60: f9400268     	ldr	x8, [x19]
   18d64: aa0003f5     	mov	x21, x0
   18d68: aa1303e0     	mov	x0, x19
   18d6c: f9404508     	ldr	x8, [x8, #0x88]
   18d70: d63f0100     	blr	x8
   18d74: 52800600     	mov	w0, #0x30               // =48
   18d78: 94004096     	bl	0x28fd0 <__cxa_allocate_exception@plt>
   18d7c: aa0003f4     	mov	x20, x0
   18d80: a900d7f5     	stp	x21, x21, [sp, #0x8]
   18d84: 910043e1     	add	x1, sp, #0x10
   18d88: 940041a2     	bl	0x29410 <_ZN8facebook3jni12JniExceptionC1ENS0_9alias_refIP11_jthrowableEE@plt>
   18d8c: f94003e8     	ldr	x8, [sp]
   18d90: f9401508     	ldr	x8, [x8, #0x28]
   18d94: f85f83a9     	ldur	x9, [x29, #-0x8]
   18d98: eb09011f     	cmp	x8, x9
   18d9c: 54000321     	b.ne	0x18e00 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv+0x158>
   18da0: f0000081     	adrp	x1, 0x2b000 <_DYNAMIC+0x170>
   18da4: f0000082     	adrp	x2, 0x2b000 <_DYNAMIC+0x170>
   18da8: aa1403e0     	mov	x0, x20
   18dac: f940d421     	ldr	x1, [x1, #0x1a8]
   18db0: f940d842     	ldr	x2, [x2, #0x1b0]
   18db4: 94004093     	bl	0x29000 <__cxa_throw@plt>
   18db8: aa0003f3     	mov	x19, x0
   18dbc: 910023e0     	add	x0, sp, #0x8
   18dc0: 9400419c     	bl	0x29430 <_ZN8facebook3jni14base_owned_refIP11_jthrowableNS0_23LocalReferenceAllocatorEED2Ev@plt>
   18dc4: 14000008     	b	0x18de4 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv+0x13c>
   18dc8: aa0003f3     	mov	x19, x0
   18dcc: 910023e0     	add	x0, sp, #0x8
   18dd0: 94004198     	bl	0x29430 <_ZN8facebook3jni14base_owned_refIP11_jthrowableNS0_23LocalReferenceAllocatorEED2Ev@plt>
   18dd4: 14000002     	b	0x18ddc <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv+0x134>
   18dd8: aa0003f3     	mov	x19, x0
   18ddc: aa1403e0     	mov	x0, x20
   18de0: 9400408c     	bl	0x29010 <__cxa_free_exception@plt>
   18de4: f94003e8     	ldr	x8, [sp]
   18de8: f9401508     	ldr	x8, [x8, #0x28]
   18dec: f85f83a9     	ldur	x9, [x29, #-0x8]
   18df0: eb09011f     	cmp	x8, x9
   18df4: 54000061     	b.ne	0x18e00 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv+0x158>
   18df8: aa1303e0     	mov	x0, x19
   18dfc: 940030c7     	bl	0x25118 <_Unwind_Resume>
   18e00: 94004060     	bl	0x28f80 <__stack_chk_fail@plt>

0000000000018e44 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEv>:
   18e44: a9bf7bfd     	stp	x29, x30, [sp, #-0x10]!
   18e48: 910003fd     	mov	x29, sp
   18e4c: 9400402d     	bl	0x28f00 <_ZN8facebook3jni11Environment7currentEv@plt>
   18e50: a8c17bfd     	ldp	x29, x30, [sp], #0x10
   18e54: 14004033     	b	0x28f20 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv@plt>
