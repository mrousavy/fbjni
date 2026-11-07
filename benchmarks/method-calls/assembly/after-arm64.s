	.file	"jvalue-wrapper-assembly.cpp"
	.text
	.globl	fbjni_nonvirtual_two_doubles    // -- Begin function fbjni_nonvirtual_two_doubles
	.p2align	2
	.type	fbjni_nonvirtual_two_doubles,@function
fbjni_nonvirtual_two_doubles:           // @fbjni_nonvirtual_two_doubles
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	d9, d8, [sp, #16]               // 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #48]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             // 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 48
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w21, -24
	.cfi_offset w22, -32
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
	stp	d9, d8, [sp]
	ldr	x3, [x21]
	mov	x4, sp
	ldr	x8, [x0]
	mov	x1, x20
	mov	x2, x19
	mov	x22, x0
	ldr	x8, [x8, #720]
	blr	x8
	mov	x0, x22
	fmov	d8, d0
	bl	_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv
	fmov	d0, d8
	.cfi_def_cfa wsp, 80
	ldp	x20, x19, [sp, #64]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             // 16-byte Folded Reload
	ldp	x29, x30, [sp, #32]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               // 16-byte Folded Reload
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
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
	stp	x29, x30, [sp, #-48]!           // 16-byte Folded Spill
	.cfi_def_cfa_offset 48
	str	x21, [sp, #16]                  // 8-byte Folded Spill
	stp	x20, x19, [sp, #32]             // 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 48
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w21, -32
	.cfi_offset w30, -40
	.cfi_offset w29, -48
	mov	x19, x1
	mov	x20, x0
	bl	_ZN8facebook3jni11Environment7currentEv
	ldr	x8, [x0]
	ldr	x2, [x20]
	mov	x1, x19
	mov	x3, xzr
	mov	x21, x0
	ldr	x8, [x8, #1048]
	blr	x8
	mov	w19, w0
	mov	x0, x21
	bl	_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv
	mov	w0, w19
	.cfi_def_cfa wsp, 48
	ldp	x20, x19, [sp, #32]             // 16-byte Folded Reload
	ldr	x21, [sp, #16]                  // 8-byte Folded Reload
	ldp	x29, x30, [sp], #48             // 16-byte Folded Reload
	.cfi_def_cfa_offset 0
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
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
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	str	d8, [sp, #32]                   // 8-byte Folded Spill
	stp	x29, x30, [sp, #48]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #64]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             // 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 64
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w21, -24
	.cfi_offset w22, -32
	.cfi_offset w23, -40
	.cfi_offset w24, -48
	.cfi_offset w30, -56
	.cfi_offset w29, -64
	.cfi_offset b8, -80
	mov	x19, x4
	mov	x20, x3
	mov	w21, w2
	fmov	s8, s0
	mov	x22, x1
	mov	x23, x0
	bl	_ZN8facebook3jni11Environment7currentEv
	fmov	w8, s8
	and	x9, x21, #0xff
	stp	x20, x19, [sp, #16]
	ldr	x2, [x23]
	mov	x3, sp
	mov	x1, x22
	mov	x24, x0
	stp	x8, x9, [sp]
	ldr	x8, [x0]
	ldr	x8, [x8, #432]
	blr	x8
	mov	x19, x0
	mov	x0, x24
	bl	_ZN8facebook3jni38throwPendingJniExceptionAsCppExceptionEP7_JNIEnv
	mov	x0, x19
	.cfi_def_cfa wsp, 112
	ldp	x20, x19, [sp, #96]             // 16-byte Folded Reload
	ldr	d8, [sp, #32]                   // 8-byte Folded Reload
	ldp	x22, x21, [sp, #80]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             // 16-byte Folded Reload
	ldp	x29, x30, [sp, #48]             // 16-byte Folded Reload
	add	sp, sp, #112
	.cfi_def_cfa_offset 0
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore b8
	ret
.Lfunc_end2:
	.size	fbjni_virtual_mixed, .Lfunc_end2-fbjni_virtual_mixed
	.cfi_endproc
                                        // -- End function
	.section	".linker-options","e",@llvm_linker_options
	.ident	"Android (13989888, +pgo, -bolt, +lto, -mlgo, based on r563880c) clang version 21.0.0 (https://android.googlesource.com/toolchain/llvm-project 5e96669f06077099aa41290cdb4c5e6fa0f59349)"
	.section	".note.GNU-stack","",@progbits
