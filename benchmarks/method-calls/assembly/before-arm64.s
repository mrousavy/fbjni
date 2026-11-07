	.file	"jvalue-wrapper-assembly.cpp"
	.text
	.globl	fbjni_nonvirtual_two_doubles    // -- Begin function fbjni_nonvirtual_two_doubles
	.p2align	2
	.type	fbjni_nonvirtual_two_doubles,@function
fbjni_nonvirtual_two_doubles:           // @fbjni_nonvirtual_two_doubles
	.cfi_startproc
// %bb.0:
	stp	d9, d8, [sp, #-64]!             // 16-byte Folded Spill
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #16]             // 16-byte Folded Spill
	str	x21, [sp, #32]                  // 8-byte Folded Spill
	stp	x20, x19, [sp, #48]             // 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 48
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w21, -32
	.cfi_offset w30, -40
	.cfi_offset w29, -48
	.cfi_offset b8, -56
	.cfi_offset b9, -64
	fmov	d8, d1
	fmov	d9, d0
	mov	x19, x2
	mov	x20, x1
	mov	x21, x0
	bl	_ZN8facebook3jni11Environment7currentEv
	fmov	d0, d9
	fmov	d1, d8
	ldr	x3, [x21]
	mov	x1, x20
	mov	x2, x19
	mov	x21, x0
	bl	_ZN7_JNIEnv26CallNonvirtualDoubleMethodEP8_jobjectP7_jclassP10_jmethodIDz
	mov	x0, x21
	fmov	d8, d0
	bl	_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv
	fmov	d0, d8
	.cfi_def_cfa wsp, 64
	ldp	x20, x19, [sp, #48]             // 16-byte Folded Reload
	ldr	x21, [sp, #32]                  // 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             // 16-byte Folded Reload
	ldp	d9, d8, [sp], #64               // 16-byte Folded Reload
	.cfi_def_cfa_offset 0
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore b8
	.cfi_restore b9
	ret
.Lfunc_end0:
	.size	fbjni_nonvirtual_two_doubles, .Lfunc_end0-fbjni_nonvirtual_two_doubles
	.cfi_endproc
                                        // -- End function
	.globl	fbjni_static_zero               // -- Begin function fbjni_static_zero
	.p2align	2
	.type	fbjni_static_zero,@function
fbjni_static_zero:                      // @fbjni_static_zero
	.cfi_startproc
// %bb.0:
	stp	x29, x30, [sp, #-32]!           // 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	stp	x20, x19, [sp, #16]             // 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 32
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w30, -24
	.cfi_offset w29, -32
	mov	x19, x1
	mov	x20, x0
	bl	_ZN8facebook3jni11Environment7currentEv
	ldr	x2, [x20]
	mov	x1, x19
	mov	x20, x0
	bl	_ZN7_JNIEnv19CallStaticIntMethodEP7_jclassP10_jmethodIDz
	mov	w19, w0
	mov	x0, x20
	bl	_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv
	mov	w0, w19
	.cfi_def_cfa wsp, 32
	ldp	x20, x19, [sp, #16]             // 16-byte Folded Reload
	ldp	x29, x30, [sp], #32             // 16-byte Folded Reload
	.cfi_def_cfa_offset 0
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end1:
	.size	fbjni_static_zero, .Lfunc_end1-fbjni_static_zero
	.cfi_endproc
                                        // -- End function
	.globl	fbjni_virtual_mixed             // -- Begin function fbjni_virtual_mixed
	.p2align	2
	.type	fbjni_virtual_mixed,@function
fbjni_virtual_mixed:                    // @fbjni_virtual_mixed
	.cfi_startproc
// %bb.0:
	str	d8, [sp, #-64]!                 // 8-byte Folded Spill
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #8]              // 16-byte Folded Spill
	str	x23, [sp, #24]                  // 8-byte Folded Spill
	stp	x22, x21, [sp, #32]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #48]             // 16-byte Folded Spill
	add	x29, sp, #8
	.cfi_def_cfa w29, 56
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w21, -24
	.cfi_offset w22, -32
	.cfi_offset w23, -40
	.cfi_offset w30, -48
	.cfi_offset w29, -56
	.cfi_offset b8, -64
	mov	x19, x4
	mov	x20, x3
	mov	w21, w2
	fmov	s8, s0
	mov	x22, x1
	mov	x23, x0
	bl	_ZN8facebook3jni11Environment7currentEv
	fcvt	d0, s8
	ldr	x2, [x23]
	sxtb	w3, w21
	mov	x1, x22
	mov	x4, x20
	mov	x5, x19
	mov	x21, x0
	bl	_ZN7_JNIEnv14CallLongMethodEP8_jobjectP10_jmethodIDz
	mov	x19, x0
	mov	x0, x21
	bl	_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv
	mov	x0, x19
	.cfi_def_cfa wsp, 64
	ldp	x20, x19, [sp, #48]             // 16-byte Folded Reload
	ldr	x23, [sp, #24]                  // 8-byte Folded Reload
	ldp	x22, x21, [sp, #32]             // 16-byte Folded Reload
	ldp	x29, x30, [sp, #8]              // 16-byte Folded Reload
	ldr	d8, [sp], #64                   // 8-byte Folded Reload
	.cfi_def_cfa_offset 0
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore b8
	ret
.Lfunc_end2:
	.size	fbjni_virtual_mixed, .Lfunc_end2-fbjni_virtual_mixed
	.cfi_endproc
                                        // -- End function
	.section	.text._ZN7_JNIEnv26CallNonvirtualDoubleMethodEP8_jobjectP7_jclassP10_jmethodIDz,"axG",@progbits,_ZN7_JNIEnv26CallNonvirtualDoubleMethodEP8_jobjectP7_jclassP10_jmethodIDz,comdat
	.weak	_ZN7_JNIEnv26CallNonvirtualDoubleMethodEP8_jobjectP7_jclassP10_jmethodIDz // -- Begin function _ZN7_JNIEnv26CallNonvirtualDoubleMethodEP8_jobjectP7_jclassP10_jmethodIDz
	.p2align	2
	.type	_ZN7_JNIEnv26CallNonvirtualDoubleMethodEP8_jobjectP7_jclassP10_jmethodIDz,@function
_ZN7_JNIEnv26CallNonvirtualDoubleMethodEP8_jobjectP7_jclassP10_jmethodIDz: // @_ZN7_JNIEnv26CallNonvirtualDoubleMethodEP8_jobjectP7_jclassP10_jmethodIDz
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #240
	.cfi_def_cfa_offset 240
	stp	x29, x30, [sp, #224]            // 16-byte Folded Spill
	add	x29, sp, #224
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	sub	x8, x29, #96
	add	x9, x29, #16
	mov	x10, sp
	add	x8, x8, #32
	stp	x4, x5, [x29, #-96]
	sub	x4, x29, #64
	stp	x9, x8, [x29, #-32]
	mov	x8, #-32                        // =0xffffffffffffffe0
	add	x9, x10, #128
	stp	x6, x7, [x29, #-80]
	movk	x8, #65408, lsl #32
	stp	q0, q1, [sp]
	stp	q2, q3, [sp, #32]
	stp	q4, q5, [sp, #64]
	stp	q6, q7, [sp, #96]
	stp	x9, x8, [x29, #-16]
	ldr	x8, [x0]
	ldp	q0, q1, [x29, #-32]
	ldr	x8, [x8, #712]
	stp	q0, q1, [x29, #-64]
	blr	x8
	.cfi_def_cfa wsp, 240
	ldp	x29, x30, [sp, #224]            // 16-byte Folded Reload
	add	sp, sp, #240
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end3:
	.size	_ZN7_JNIEnv26CallNonvirtualDoubleMethodEP8_jobjectP7_jclassP10_jmethodIDz, .Lfunc_end3-_ZN7_JNIEnv26CallNonvirtualDoubleMethodEP8_jobjectP7_jclassP10_jmethodIDz
	.cfi_endproc
                                        // -- End function
	.section	.text._ZN7_JNIEnv19CallStaticIntMethodEP7_jclassP10_jmethodIDz,"axG",@progbits,_ZN7_JNIEnv19CallStaticIntMethodEP7_jclassP10_jmethodIDz,comdat
	.weak	_ZN7_JNIEnv19CallStaticIntMethodEP7_jclassP10_jmethodIDz // -- Begin function _ZN7_JNIEnv19CallStaticIntMethodEP7_jclassP10_jmethodIDz
	.p2align	2
	.type	_ZN7_JNIEnv19CallStaticIntMethodEP7_jclassP10_jmethodIDz,@function
_ZN7_JNIEnv19CallStaticIntMethodEP7_jclassP10_jmethodIDz: // @_ZN7_JNIEnv19CallStaticIntMethodEP7_jclassP10_jmethodIDz
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #256
	.cfi_def_cfa_offset 256
	stp	x29, x30, [sp, #240]            // 16-byte Folded Spill
	add	x29, sp, #240
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	sub	x8, x29, #104
	add	x9, x29, #16
	mov	x10, sp
	add	x8, x8, #40
	stp	x3, x4, [x29, #-104]
	sub	x3, x29, #64
	stp	x9, x8, [x29, #-32]
	mov	x8, #-40                        // =0xffffffffffffffd8
	add	x9, x10, #128
	stp	x5, x6, [x29, #-88]
	movk	x8, #65408, lsl #32
	stur	x7, [x29, #-72]
	stp	q0, q1, [sp]
	stp	q2, q3, [sp, #32]
	stp	q4, q5, [sp, #64]
	stp	q6, q7, [sp, #96]
	stp	x9, x8, [x29, #-16]
	ldr	x8, [x0]
	ldp	q0, q1, [x29, #-32]
	ldr	x8, [x8, #1040]
	stp	q0, q1, [x29, #-64]
	blr	x8
	.cfi_def_cfa wsp, 256
	ldp	x29, x30, [sp, #240]            // 16-byte Folded Reload
	add	sp, sp, #256
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end4:
	.size	_ZN7_JNIEnv19CallStaticIntMethodEP7_jclassP10_jmethodIDz, .Lfunc_end4-_ZN7_JNIEnv19CallStaticIntMethodEP7_jclassP10_jmethodIDz
	.cfi_endproc
                                        // -- End function
	.section	.text._ZN7_JNIEnv14CallLongMethodEP8_jobjectP10_jmethodIDz,"axG",@progbits,_ZN7_JNIEnv14CallLongMethodEP8_jobjectP10_jmethodIDz,comdat
	.weak	_ZN7_JNIEnv14CallLongMethodEP8_jobjectP10_jmethodIDz // -- Begin function _ZN7_JNIEnv14CallLongMethodEP8_jobjectP10_jmethodIDz
	.p2align	2
	.type	_ZN7_JNIEnv14CallLongMethodEP8_jobjectP10_jmethodIDz,@function
_ZN7_JNIEnv14CallLongMethodEP8_jobjectP10_jmethodIDz: // @_ZN7_JNIEnv14CallLongMethodEP8_jobjectP10_jmethodIDz
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #256
	.cfi_def_cfa_offset 256
	stp	x29, x30, [sp, #240]            // 16-byte Folded Spill
	add	x29, sp, #240
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	sub	x8, x29, #104
	add	x9, x29, #16
	mov	x10, sp
	add	x8, x8, #40
	stp	x3, x4, [x29, #-104]
	sub	x3, x29, #64
	stp	x9, x8, [x29, #-32]
	mov	x8, #-40                        // =0xffffffffffffffd8
	add	x9, x10, #128
	stp	x5, x6, [x29, #-88]
	movk	x8, #65408, lsl #32
	stur	x7, [x29, #-72]
	stp	q0, q1, [sp]
	stp	q2, q3, [sp, #32]
	stp	q4, q5, [sp, #64]
	stp	q6, q7, [sp, #96]
	stp	x9, x8, [x29, #-16]
	ldr	x8, [x0]
	ldp	q0, q1, [x29, #-32]
	ldr	x8, [x8, #424]
	stp	q0, q1, [x29, #-64]
	blr	x8
	.cfi_def_cfa wsp, 256
	ldp	x29, x30, [sp, #240]            // 16-byte Folded Reload
	add	sp, sp, #256
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end5:
	.size	_ZN7_JNIEnv14CallLongMethodEP8_jobjectP10_jmethodIDz, .Lfunc_end5-_ZN7_JNIEnv14CallLongMethodEP8_jobjectP10_jmethodIDz
	.cfi_endproc
                                        // -- End function
	.section	".linker-options","e",@llvm_linker_options
	.ident	"Android (13989888, +pgo, -bolt, +lto, -mlgo, based on r563880c) clang version 21.0.0 (https://android.googlesource.com/toolchain/llvm-project 5e96669f06077099aa41290cdb4c5e6fa0f59349)"
	.section	".note.GNU-stack","",@progbits
