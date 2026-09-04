
/tmp/fbjni-env-validation.sbf8z9/android-before/libfbjni.so:	file format elf64-littleaarch64

Disassembly of section .text:

0000000000018b7c <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEv>:
   18b7c: d10143ff     	sub	sp, sp, #0x50
   18b80: a9027bfd     	stp	x29, x30, [sp, #0x20]
   18b84: f9001bf5     	str	x21, [sp, #0x30]
   18b88: a9044ff4     	stp	x20, x19, [sp, #0x40]
   18b8c: 910083fd     	add	x29, sp, #0x20
   18b90: d53bd054     	mrs	x20, TPIDR_EL0
   18b94: f9401688     	ldr	x8, [x20, #0x28]
   18b98: f81f83a8     	stur	x8, [x29, #-0x8]
   18b9c: 94004011     	bl	0x28be0 <_ZN8facebook3jni11Environment7currentEv@plt>
   18ba0: f9400008     	ldr	x8, [x0]
   18ba4: aa0003f3     	mov	x19, x0
   18ba8: f9439108     	ldr	x8, [x8, #0x720]
   18bac: d63f0100     	blr	x8
   18bb0: 72001c1f     	tst	w0, #0xff
   18bb4: 54000141     	b.ne	0x18bdc <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEv+0x60>
   18bb8: f9401688     	ldr	x8, [x20, #0x28]
   18bbc: f85f83a9     	ldur	x9, [x29, #-0x8]
   18bc0: eb09011f     	cmp	x8, x9
   18bc4: 540008a1     	b.ne	0x18cd8 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEv+0x15c>
   18bc8: a9444ff4     	ldp	x20, x19, [sp, #0x40]
   18bcc: f9401bf5     	ldr	x21, [sp, #0x30]
   18bd0: a9427bfd     	ldp	x29, x30, [sp, #0x20]
   18bd4: 910143ff     	add	sp, sp, #0x50
   18bd8: d65f03c0     	ret
   18bdc: f9400268     	ldr	x8, [x19]
   18be0: aa1303e0     	mov	x0, x19
   18be4: f90003f4     	str	x20, [sp]
   18be8: f9403d08     	ldr	x8, [x8, #0x78]
   18bec: d63f0100     	blr	x8
   18bf0: b5000240     	cbnz	x0, 0x18c38 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEv+0xbc>
   18bf4: 52800200     	mov	w0, #0x10               // =16
   18bf8: 9400402a     	bl	0x28ca0 <__cxa_allocate_exception@plt>
   18bfc: aa0003f4     	mov	x20, x0
   18c00: d503201f     	nop
   18c04: 50fb2961     	adr	x1, 0xf132 <syscall+0xf132>
   18c08: 9400402e     	bl	0x28cc0 <_ZNSt13runtime_errorC1EPKc@plt>
   18c0c: f94003e8     	ldr	x8, [sp]
   18c10: f9401508     	ldr	x8, [x8, #0x28]
   18c14: f85f83a9     	ldur	x9, [x29, #-0x8]
   18c18: eb09011f     	cmp	x8, x9
   18c1c: 540005e1     	b.ne	0x18cd8 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEv+0x15c>
   18c20: d0000081     	adrp	x1, 0x2a000 <fwrite@plt+0x790>
   18c24: d0000082     	adrp	x2, 0x2a000 <fwrite@plt+0x790>
   18c28: aa1403e0     	mov	x0, x20
   18c2c: f946a021     	ldr	x1, [x1, #0xd40]
   18c30: f946a442     	ldr	x2, [x2, #0xd48]
   18c34: 94004027     	bl	0x28cd0 <__cxa_throw@plt>
   18c38: f9400268     	ldr	x8, [x19]
   18c3c: aa0003f5     	mov	x21, x0
   18c40: aa1303e0     	mov	x0, x19
   18c44: f9404508     	ldr	x8, [x8, #0x88]
   18c48: d63f0100     	blr	x8
   18c4c: 52800600     	mov	w0, #0x30               // =48
   18c50: 94004014     	bl	0x28ca0 <__cxa_allocate_exception@plt>
   18c54: aa0003f4     	mov	x20, x0
   18c58: a900d7f5     	stp	x21, x21, [sp, #0x8]
   18c5c: 910043e1     	add	x1, sp, #0x10
   18c60: 94004120     	bl	0x290e0 <_ZN8facebook3jni12JniExceptionC1ENS0_9alias_refIP11_jthrowableEE@plt>
   18c64: f94003e8     	ldr	x8, [sp]
   18c68: f9401508     	ldr	x8, [x8, #0x28]
   18c6c: f85f83a9     	ldur	x9, [x29, #-0x8]
   18c70: eb09011f     	cmp	x8, x9
   18c74: 54000321     	b.ne	0x18cd8 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEv+0x15c>
   18c78: d0000081     	adrp	x1, 0x2a000 <fwrite@plt+0x790>
   18c7c: d0000082     	adrp	x2, 0x2a000 <fwrite@plt+0x790>
   18c80: aa1403e0     	mov	x0, x20
   18c84: f9473c21     	ldr	x1, [x1, #0xe78]
   18c88: f9474042     	ldr	x2, [x2, #0xe80]
   18c8c: 94004011     	bl	0x28cd0 <__cxa_throw@plt>
   18c90: aa0003f3     	mov	x19, x0
   18c94: 910023e0     	add	x0, sp, #0x8
   18c98: 9400411a     	bl	0x29100 <_ZN8facebook3jni14base_owned_refIP11_jthrowableNS0_23LocalReferenceAllocatorEED2Ev@plt>
   18c9c: 14000008     	b	0x18cbc <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEv+0x140>
   18ca0: aa0003f3     	mov	x19, x0
   18ca4: 910023e0     	add	x0, sp, #0x8
   18ca8: 94004116     	bl	0x29100 <_ZN8facebook3jni14base_owned_refIP11_jthrowableNS0_23LocalReferenceAllocatorEED2Ev@plt>
   18cac: 14000002     	b	0x18cb4 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEv+0x138>
   18cb0: aa0003f3     	mov	x19, x0
   18cb4: aa1403e0     	mov	x0, x20
   18cb8: 9400400a     	bl	0x28ce0 <__cxa_free_exception@plt>
   18cbc: f94003e8     	ldr	x8, [sp]
   18cc0: f9401508     	ldr	x8, [x8, #0x28]
   18cc4: f85f83a9     	ldur	x9, [x29, #-0x8]
   18cc8: eb09011f     	cmp	x8, x9
   18ccc: 54000061     	b.ne	0x18cd8 <_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEv+0x15c>
   18cd0: aa1303e0     	mov	x0, x19
   18cd4: 9400304b     	bl	0x24e00 <_Unwind_Resume>
   18cd8: 94003fe2     	bl	0x28c60 <__stack_chk_fail@plt>
