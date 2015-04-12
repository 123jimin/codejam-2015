%char = type i8
%byte = type i8
%int = type i64

@HARR = internal constant [16 x %byte] c"\00\01\02\03\01\04\03\06\02\07\04\01\03\02\05\04"

@casey = internal constant [17 x %char] c"Case #%lld: YES\0A\00"
@casen = internal constant [16 x %char] c"Case #%lld: NO\0A\00"
@dinf = internal constant [5 x %char] c"%lld\00"
@din2f = internal constant [10 x %char] c"%lld %lld\00"
@doutf = internal constant [6 x %char] c"%lld\0A\00"

@str = common global [10005 x %byte] zeroinitializer, align 8

declare %int @printf(%char* noalias nocapture, ...)
declare %int @scanf(%char* noalias nocapture, ...)
declare %char @getchar()

define void @printInt(%int %v) {
	call %int (%char*, ...)* @printf(%char* getelementptr ([6 x %char]* @doutf, %int 0, %int 0), %int %v)
	ret void
}

define %byte @prod(%byte %x, %byte %y) {
	%xl = and %byte 3, %x
	%yl = and %byte 3, %y
	%xh = and %byte 4, %x
	%yh = and %byte 4, %y
	%load1 = shl %byte %xl, 2
	%load2 = or %byte %load1, %yl
	%load2.ext = zext %byte %load2 to i64
	%sgn = xor %byte %xh, %yh
	%ptr = getelementptr [16 x %byte]* @HARR, i64 0, i64 %load2.ext
	%look = load i8* %ptr
	%res = xor %byte %look, %sgn
	ret %byte %res
}

define %int @realX(%int %X) {
	%X.cmp = icmp ult %int %X, 13
	br i1 %X.cmp, label %realX.original, label %realX.cut
realX.original:
	ret %int %X

realX.cut:
	%X.m = urem %int %X, 4
	%X.r = add %int %X.m, 12
	ret %int %X.r
}

define %int @main() {
init:
	%T.mem = alloca %int
	%L.mem = alloca %int
	%X.mem = alloca %int
	call %int (%char*, ...)* @scanf(%char* getelementptr ([5 x %char]* @dinf, %int 0, %int 0), %int* %T.mem)
	%T = load %int* %T.mem
	br label %tc_loop
tc_loop:
	%ti = phi %int [1, %init], [%ti.next, %out_branch.after]
	call %int (%char*, ...)* @scanf(%char* getelementptr ([10 x %char]* @din2f, %int 0, %int 0), %int* %L.mem, %int* %X.mem)
	call %char @getchar()
	
	%L = load %int* %L.mem
	%X = load %int* %X.mem

	%X.r = call %int @realX(%int %X)

	br label %read_loop
read_loop:
	; Read strings
	%Si = phi %int [0, %tc_loop], [%Si.next, %read_loop]
	%strptr.fetch = getelementptr [10005 x %byte]* @str, i64 0, i64 %Si
	
	%ch = call %char @getchar()
	%ch.i = sub %char %ch, 104

	store %byte %ch.i, %byte* %strptr.fetch
	
	%Si.next = add %int %Si, 1
	%read_loop.cond = icmp ult %int %Si.next, %L
	br i1 %read_loop.cond, label %read_loop, label %comp_loop.outer
comp_loop.outer:
	%curr.prod = phi %byte [0, %read_loop], [%curr.prod.next, %comp_loop.inner.after]
	%i.made = phi i1 [0, %read_loop], [%i.made.next, %comp_loop.inner.after]
	%k.made = phi i1 [0, %read_loop], [%k.made.next, %comp_loop.inner.after]

	%X.i = phi %int [0, %read_loop], [%X.i.next, %comp_loop.inner.after]
	br label %comp_loop.inner

comp_loop.inner:
	%curr.prod.inner = phi %byte [%curr.prod, %comp_loop.outer], [%curr.prod.next, %comp_loop.inner]
	%i.made.inner = phi i1 [%i.made, %comp_loop.outer], [%i.made.next, %comp_loop.inner]
	%k.made.inner = phi i1 [%k.made, %comp_loop.outer], [%k.made.next, %comp_loop.inner]

	%nn = phi %int [0, %comp_loop.outer], [%nn.next, %comp_loop.inner]
	%chr.fetch = getelementptr [10005 x %byte]* @str, i64 0, i64 %nn
	%chr = load %byte* %chr.fetch

	%curr.prod.next = call %byte @prod(%byte %curr.prod.inner, %byte %chr)

	%curr.prod.is.i = icmp eq %byte %curr.prod.next, 1
	%curr.prod.is.k = icmp eq %byte %curr.prod.next, 3

	%i.made.next = or i1 %i.made.inner, %curr.prod.is.i
	%k.made.cond = and i1 %i.made.inner, %curr.prod.is.k
	%k.made.next = or i1 %k.made.inner, %k.made.cond

	%nn.next = add %int %nn, 1
	%comp_loop.inner.cond = icmp ult %int %nn.next, %L
	br i1 %comp_loop.inner.cond, label %comp_loop.inner, label %comp_loop.inner.after
	
comp_loop.inner.after:

	%X.i.next = add %int %X.i, 1
	%comp_loop.outer.cond = icmp ult %int %X.i.next, %X.r
	br i1 %comp_loop.outer.cond, label %comp_loop.outer, label %comp_loop.after
comp_loop.after:

	; Print results
	%ok.a = and i1 %i.made.next, %k.made.next
	%ok.b = icmp eq %byte %curr.prod.next, 4
	%ok.c = and i1 %ok.a, %ok.b

	br i1 %ok.c, label %out_branch.yes, label %out_branch.no

out_branch.no:
	call %int (%char*, ...)* @printf(%char* getelementptr ([16 x %char]* @casen, %int 0, %int 0), %int %ti)
	br label %out_branch.after

out_branch.yes:
	call %int (%char*, ...)* @printf(%char* getelementptr ([17 x %char]* @casey, %int 0, %int 0), %int %ti)
	br label %out_branch.after

out_branch.after:

	; Condition checking (outer loop)
	%ti.next = add %int %ti, 1
	
	%cond.t = icmp ule %int %ti.next, %T
	br i1 %cond.t, label %tc_loop, label %exit
exit:
	ret %int 0
}
