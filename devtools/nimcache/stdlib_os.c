/* Generated by Nim Compiler v0.18.0 */
/*   (c) 2018 Andreas Rumpf */
/* The generated code is subject to the original license. */
/* Compiled for: Linux, amd64, gcc */
/* Command for C compiler:
   gcc -c  -w  -I/usr/lib/nim -o /home/user/Dropbox/projects/nim/stui/devtools/nimcache/stdlib_os.o /home/user/Dropbox/projects/nim/stui/devtools/nimcache/stdlib_os.c */
#define NIM_NEW_MANGLING_RULES
#define NIM_INTBITS 64

#include "nimbase.h"
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#undef LANGUAGE_C
#undef MIPSEB
#undef MIPSEL
#undef PPC
#undef R3000
#undef R4000
#undef i386
#undef linux
#undef mips
#undef near
#undef powerpc
#undef unix
typedef struct NimStringDesc NimStringDesc;
typedef struct TGenericSeq TGenericSeq;
typedef struct tySequence_sM4lkSb7zS6F7OVMvW9cffQ tySequence_sM4lkSb7zS6F7OVMvW9cffQ;
typedef struct TNimType TNimType;
typedef struct TNimNode TNimNode;
struct TGenericSeq {
NI len;
NI reserved;
};
struct NimStringDesc {
  TGenericSeq Sup;
NIM_CHAR data[SEQ_DECL_SIZE];
};
typedef NU8 tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A;
typedef NU8 tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ;
typedef N_NIMCALL_PTR(void, tyProc_ojoeKfW4VYIm36I9cpDTQIg) (void* p, NI op);
typedef N_NIMCALL_PTR(void*, tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ) (void* p);
struct TNimType {
NI size;
tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A kind;
tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ flags;
TNimType* base;
TNimNode* node;
void* finalizer;
tyProc_ojoeKfW4VYIm36I9cpDTQIg marker;
tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ deepcopy;
};
typedef NU8 tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ;
typedef NU8 tyEnum_WalkOp_Wfy7gT5VQ8B3aJBxqU8D9cQ;
typedef long tyArray_QS4edQct6fXoghbs69aZ9a8w[3];
typedef NU8 tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ;
struct TNimNode {
tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ kind;
NI offset;
TNimType* typ;
NCSTRING name;
NI len;
TNimNode** sons;
};
struct tySequence_sM4lkSb7zS6F7OVMvW9cffQ {
  TGenericSeq Sup;
  NimStringDesc* data[SEQ_DECL_SIZE];
};
static N_INLINE(NimStringDesc*, pop_9cDsfK2acP02vJ9bhxIE9caEAos)(tySequence_sM4lkSb7zS6F7OVMvW9cffQ** s);
static N_INLINE(NI, subInt)(NI a, NI b);
N_NOINLINE(void, raiseOverflow)(void);
N_NOINLINE(void, raiseIndexError)(void);
N_NIMCALL(NimStringDesc*, copyString)(NimStringDesc* src);
static N_INLINE(NI, chckRange)(NI i, NI a, NI b);
N_NOINLINE(void, raiseRangeError)(NI64 val);
static N_INLINE(TGenericSeq*, setLengthSeq)(TGenericSeq* seq, NI elemSize, NI newLen);
static N_INLINE(NI, resize_bzF9a0JivP3Z4njqaxuLc5wsystem)(NI old);
N_LIB_PRIVATE N_NIMCALL(void*, growObj_AVYny8c0GTk28gxjmat1MA)(void* old, NI newsize);
N_NIMCALL(TNimType*, extGetCellType)(void* c);
N_LIB_PRIVATE N_NIMCALL(void, forAllChildrenAux_YOI1Uo54H9aas13WthjhsfA)(void* dest, TNimType* mt, tyEnum_WalkOp_Wfy7gT5VQ8B3aJBxqU8D9cQ op);
static N_INLINE(void, zeroMem_t0o5XqKanO5QJfXMGEzp2Asystem)(void* p, NI size);
static N_INLINE(void, nimFrame)(TFrame* s);
N_LIB_PRIVATE N_NOINLINE(void, stackOverflow_II46IjNZztN9bmbxUD8dt8g)(void);
static N_INLINE(void, popFrame)(void);
N_LIB_PRIVATE N_NIMCALL(NIM_BOOL, contains_6e5MGL10HDAJ205lBYpWxw)(NimStringDesc* s, NIM_CHAR c);
N_LIB_PRIVATE N_NIMCALL(NimStringDesc*, nosaddFileExt)(NimStringDesc* filename, NimStringDesc* ext);
N_LIB_PRIVATE N_NIMCALL(NIM_BOOL, nosexistsFile)(NimStringDesc* filename);
static N_INLINE(NI, addInt)(NI a, NI b);
N_LIB_PRIVATE N_NIMCALL(NimStringDesc*, getEnv_9b1nh9cAHhSLlHOPz8lCk5FA)(NimStringDesc* key, NimStringDesc* default_0);
N_NIMCALL(NimStringDesc*, copyStrLast)(NimStringDesc* s, NI start, NI last);
N_NIMCALL(NimStringDesc*, copyStrLast)(NimStringDesc* s, NI first, NI last);
N_LIB_PRIVATE N_NIMCALL(NimStringDesc*, slash__lXoMhn1ZYc9cAJa9bfA61msg)(NimStringDesc* head, NimStringDesc* tail);
N_LIB_PRIVATE N_NIMCALL(NimStringDesc*, expandTilde_DOCYVvghSr9cSjyIq0voF3g)(NimStringDesc* path);
N_LIB_PRIVATE N_NIMCALL(NIM_BOOL, checkSymlink_KkZgXPy74tXi49bh8QSie8g)(NimStringDesc* path);
N_NIMCALL(NimStringDesc*, mnewString)(NI len);
N_NIMCALL(NimStringDesc*, mnewString)(NI len);
N_LIB_PRIVATE N_NOINLINE(void, raiseOSError_bEwAamo1N7TKcaU9akpiyIg)(NI32 errorCode, NimStringDesc* additionalInfo);
N_LIB_PRIVATE N_NIMCALL(NI32, osLastError_tNPXXFl9cb3BG0pJKzUn9bew)(void);
N_NIMCALL(NimStringDesc*, setLengthStr)(NimStringDesc* s, NI newLen);
N_LIB_PRIVATE N_NIMCALL(NIM_BOOL, nosisAbsolute)(NimStringDesc* path);
N_LIB_PRIVATE N_NIMCALL(NimStringDesc*, nosparentDir)(NimStringDesc* path);
extern int cmdCount;
extern NCSTRING* cmdLine;
extern TFrame* framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;
STRING_LITERAL(TM_yu6cxgKBBXbNsTkT9cyMd4g_4, "PATH", 4);
STRING_LITERAL(TM_yu6cxgKBBXbNsTkT9cyMd4g_5, "", 0);

static N_INLINE(NI, subInt)(NI a, NI b) {
	NI result;
{	result = (NI)0;
	result = (NI)((NU64)(a) - (NU64)(b));
	{
		NIM_BOOL T3_;
		T3_ = (NIM_BOOL)0;
		T3_ = (((NI) 0) <= (NI)(result ^ a));
		if (T3_) goto LA4_;
		T3_ = (((NI) 0) <= (NI)(result ^ (NI)((NU64) ~(b))));
		LA4_: ;
		if (!T3_) goto LA5_;
		goto BeforeRet_;
	}
	LA5_: ;
	raiseOverflow();
	}BeforeRet_: ;
	return result;
}

static N_INLINE(NI, chckRange)(NI i, NI a, NI b) {
	NI result;
{	result = (NI)0;
	{
		NIM_BOOL T3_;
		T3_ = (NIM_BOOL)0;
		T3_ = (a <= i);
		if (!(T3_)) goto LA4_;
		T3_ = (i <= b);
		LA4_: ;
		if (!T3_) goto LA5_;
		result = i;
		goto BeforeRet_;
	}
	goto LA1_;
	LA5_: ;
	{
		raiseRangeError(((NI64) (i)));
	}
	LA1_: ;
	}BeforeRet_: ;
	return result;
}

static N_INLINE(NI, resize_bzF9a0JivP3Z4njqaxuLc5wsystem)(NI old) {
	NI result;
	result = (NI)0;
	{
		if (!(old <= ((NI) 0))) goto LA3_;
		result = ((NI) 4);
	}
	goto LA1_;
	LA3_: ;
	{
		if (!(old < ((NI) 65536))) goto LA6_;
		result = (NI)(old * ((NI) 2));
	}
	goto LA1_;
	LA6_: ;
	{
		result = (NI)((NI)(old * ((NI) 3)) / ((NI) 2));
	}
	LA1_: ;
	return result;
}

static N_INLINE(void, zeroMem_t0o5XqKanO5QJfXMGEzp2Asystem)(void* p, NI size) {
	void* T1_;
	T1_ = (void*)0;
	T1_ = memset(p, ((int) 0), ((size_t) (size)));
}

static N_INLINE(TGenericSeq*, setLengthSeq)(TGenericSeq* seq, NI elemSize, NI newLen) {
	TGenericSeq* result;
	result = (TGenericSeq*)0;
	result = seq;
	{
		NI r;
		NI T5_;
		void* T6_;
		if (!((NI)((*result).reserved & ((NI) IL64(4611686018427387903))) < newLen)) goto LA3_;
		T5_ = (NI)0;
		T5_ = resize_bzF9a0JivP3Z4njqaxuLc5wsystem((NI)((*result).reserved & ((NI) IL64(4611686018427387903))));
		r = ((T5_ >= newLen) ? T5_ : newLen);
		T6_ = (void*)0;
		T6_ = growObj_AVYny8c0GTk28gxjmat1MA(((void*) (result)), (NI)((NI)(elemSize * r) + ((NI) 16)));
		result = ((TGenericSeq*) (T6_));
		(*result).reserved = r;
	}
	goto LA1_;
	LA3_: ;
	{
		if (!(newLen < (*result).len)) goto LA8_;
		{
			TNimType* T12_;
			T12_ = (TNimType*)0;
			T12_ = extGetCellType(((void*) (result)));
			if (!!((((*(*T12_).base).flags &(1U<<((NU)(((tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ) 0))&7U)))!=0))) goto LA13_;
			{
				NI i;
				NI colontmp_;
				NI res;
				i = (NI)0;
				colontmp_ = (NI)0;
				colontmp_ = (NI)((*result).len - ((NI) 1));
				res = newLen;
				{
					while (1) {
						TNimType* T18_;
						if (!(res <= colontmp_)) goto LA17;
						i = res;
						T18_ = (TNimType*)0;
						T18_ = extGetCellType(((void*) (result)));
						forAllChildrenAux_YOI1Uo54H9aas13WthjhsfA(((void*) ((NI)((NU64)((NI)((NU64)(((NI) (ptrdiff_t) (result))) + (NU64)(((NI) 16)))) + (NU64)((NI)((NU64)(i) * (NU64)(elemSize)))))), (*T18_).base, ((tyEnum_WalkOp_Wfy7gT5VQ8B3aJBxqU8D9cQ) 2));
						res += ((NI) 1);
					} LA17: ;
				}
			}
		}
		LA13_: ;
		zeroMem_t0o5XqKanO5QJfXMGEzp2Asystem(((void*) ((NI)((NU64)((NI)((NU64)(((NI) (ptrdiff_t) (result))) + (NU64)(((NI) 16)))) + (NU64)((NI)((NU64)(newLen) * (NU64)(elemSize)))))), ((NI) ((NI)((NU64)((NI)((NU64)((*result).len) - (NU64)(newLen))) * (NU64)(elemSize)))));
	}
	goto LA1_;
	LA8_: ;
	LA1_: ;
	(*result).len = newLen;
	return result;
}

static N_INLINE(void, nimFrame)(TFrame* s) {
	NI T1_;
	T1_ = (NI)0;
	{
		if (!(framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw == NIM_NIL)) goto LA4_;
		T1_ = ((NI) 0);
	}
	goto LA2_;
	LA4_: ;
	{
		T1_ = ((NI) ((NI16)((*framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw).calldepth + ((NI16) 1))));
	}
	LA2_: ;
	(*s).calldepth = ((NI16) (T1_));
	(*s).prev = framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;
	framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw = s;
	{
		if (!((*s).calldepth == ((NI16) 2000))) goto LA9_;
		stackOverflow_II46IjNZztN9bmbxUD8dt8g();
	}
	LA9_: ;
}

static N_INLINE(void, popFrame)(void) {
	framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw = (*framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw).prev;
}

static N_INLINE(NimStringDesc*, pop_9cDsfK2acP02vJ9bhxIE9caEAos)(tySequence_sM4lkSb7zS6F7OVMvW9cffQ** s) {
	NimStringDesc* result;
	NI L;
	NI T1_;
	NI TM_yu6cxgKBBXbNsTkT9cyMd4g_2;
	nimfr_("pop", "system.nim");
	result = (NimStringDesc*)0;
	nimln_(2431, "system.nim");
	T1_ = ((*s) ? (*s)->Sup.len : 0);
	TM_yu6cxgKBBXbNsTkT9cyMd4g_2 = subInt(T1_, ((NI) 1));
	L = (NI)(TM_yu6cxgKBBXbNsTkT9cyMd4g_2);
	nimln_(2432, "system.nim");
	if ((NU)(L) >= (NU)((*s)->Sup.len)) raiseIndexError();
	result = copyString((*s)->data[L]);
	nimln_(2433, "system.nim");
	(*s) = (tySequence_sM4lkSb7zS6F7OVMvW9cffQ*) setLengthSeq(&((*s))->Sup, sizeof(NimStringDesc*), ((NI)chckRange(L, ((NI) 0), ((NI) IL64(9223372036854775807)))));
	popFrame();
	return result;
}

N_LIB_PRIVATE N_NIMCALL(NIM_BOOL, nosexistsFile)(NimStringDesc* filename) {
	NIM_BOOL result;
	struct stat res;
	NIM_BOOL T1_;
	int T2_;
	nimfr_("existsFile", "os.nim");
{	result = (NIM_BOOL)0;
	memset((void*)(&res), 0, sizeof(res));
	nimln_(83, "os.nim");
	T1_ = (NIM_BOOL)0;
	T2_ = (int)0;
	T2_ = stat(filename->data, (&res));
	T1_ = (((NI32) 0) <= T2_);
	if (!(T1_)) goto LA3_;
	T1_ = S_ISREG(res.st_mode);
	LA3_: ;
	result = T1_;
	goto BeforeRet_;
	}BeforeRet_: ;
	popFrame();
	return result;
}

static N_INLINE(NI, addInt)(NI a, NI b) {
	NI result;
{	result = (NI)0;
	result = (NI)((NU64)(a) + (NU64)(b));
	{
		NIM_BOOL T3_;
		T3_ = (NIM_BOOL)0;
		T3_ = (((NI) 0) <= (NI)(result ^ a));
		if (T3_) goto LA4_;
		T3_ = (((NI) 0) <= (NI)(result ^ b));
		LA4_: ;
		if (!T3_) goto LA5_;
		goto BeforeRet_;
	}
	LA5_: ;
	raiseOverflow();
	}BeforeRet_: ;
	return result;
}

N_LIB_PRIVATE N_NIMCALL(NIM_BOOL, checkSymlink_KkZgXPy74tXi49bh8QSie8g)(NimStringDesc* path) {
	NIM_BOOL result;
	struct stat rawInfo;
	nimfr_("checkSymlink", "os.nim");
	result = (NIM_BOOL)0;
	memset((void*)(&rawInfo), 0, sizeof(rawInfo));
	nimln_(125, "os.nim");
	{
		int T3_;
		T3_ = (int)0;
		T3_ = lstat(path->data, (&rawInfo));
		if (!(T3_ < ((NI32) 0))) goto LA4_;
		result = NIM_FALSE;
	}
	goto LA1_;
	LA4_: ;
	{
		nimln_(126, "os.nim");
		result = S_ISLNK(rawInfo.st_mode);
	}
	LA1_: ;
	popFrame();
	return result;
}

N_LIB_PRIVATE N_NIMCALL(NimStringDesc*, findExe_XcLgn9booQ6akyBsF074Lfw)(NimStringDesc* exe, NIM_BOOL followSymlinks, NimStringDesc** extensions, NI extensionsLen_0) {
	NimStringDesc* result;
	NimStringDesc* path;
	nimfr_("findExe", "os.nim");
{	result = (NimStringDesc*)0;
	nimln_(147, "os.nim");
	{
		NIM_BOOL T3_;
		T3_ = (NIM_BOOL)0;
		T3_ = contains_6e5MGL10HDAJ205lBYpWxw(exe, 47);
		if (!T3_) goto LA4_;
		{
			NimStringDesc* ext;
			NI i;
			ext = (NimStringDesc*)0;
			nimln_(2185, "system.nim");
			i = ((NI) 0);
			{
				nimln_(2186, "system.nim");
				while (1) {
					NI TM_yu6cxgKBBXbNsTkT9cyMd4g_3;
					if (!(i < extensionsLen_0)) goto LA8;
					nimln_(2187, "system.nim");
					if ((NU)(i) >= (NU)(extensionsLen_0)) raiseIndexError();
					ext = extensions[i];
					nimln_(144, "os.nim");
					result = nosaddFileExt(exe, ext);
					nimln_(145, "os.nim");
					{
						NIM_BOOL T11_;
						T11_ = (NIM_BOOL)0;
						T11_ = nosexistsFile(result);
						if (!T11_) goto LA12_;
						goto BeforeRet_;
					}
					LA12_: ;
					nimln_(2188, "system.nim");
					TM_yu6cxgKBBXbNsTkT9cyMd4g_3 = addInt(i, ((NI) 1));
					i = (NI)(TM_yu6cxgKBBXbNsTkT9cyMd4g_3);
				} LA8: ;
			}
		}
	}
	LA4_: ;
	nimln_(150, "os.nim");
	path = getEnv_9b1nh9cAHhSLlHOPz8lCk5FA(((NimStringDesc*) &TM_yu6cxgKBBXbNsTkT9cyMd4g_4), ((NimStringDesc*) &TM_yu6cxgKBBXbNsTkT9cyMd4g_5));
	{
		NimStringDesc* candidate;
		NI last;
		NI splits;
		candidate = (NimStringDesc*)0;
		nimln_(502, "strutils.nim");
		last = ((NI) 0);
		nimln_(503, "strutils.nim");
		splits = ((NI) -1);
		{
			nimln_(641, "strutils.nim");
			while (1) {
				NI first;
				NI TM_yu6cxgKBBXbNsTkT9cyMd4g_7;
				NimStringDesc* x;
				NimStringDesc* T25_;
				NI TM_yu6cxgKBBXbNsTkT9cyMd4g_10;
				NI TM_yu6cxgKBBXbNsTkT9cyMd4g_11;
				nimln_(505, "strutils.nim");
				nimln_(641, "strutils.nim");
				if (!(last <= (path ? path->Sup.len : 0))) goto LA16;
				nimln_(506, "strutils.nim");
				first = last;
				{
					nimln_(507, "strutils.nim");
					while (1) {
						NIM_BOOL T19_;
						NI TM_yu6cxgKBBXbNsTkT9cyMd4g_6;
						T19_ = (NIM_BOOL)0;
						nimln_(641, "strutils.nim");
						T19_ = (last < (path ? path->Sup.len : 0));
						if (!(T19_)) goto LA20_;
						nimln_(507, "strutils.nim");
						nimln_(495, "strutils.nim");
						if ((NU)(last) > (NU)(path->Sup.len)) raiseIndexError();
						T19_ = !(((NU8)(path->data[last]) == (NU8)(58)));
						LA20_: ;
						if (!T19_) goto LA18;
						nimln_(508, "strutils.nim");
						TM_yu6cxgKBBXbNsTkT9cyMd4g_6 = addInt(last, ((NI) 1));
						last = (NI)(TM_yu6cxgKBBXbNsTkT9cyMd4g_6);
					} LA18: ;
				}
				nimln_(509, "strutils.nim");
				{
					if (!(splits == ((NI) 0))) goto LA23_;
					nimln_(641, "strutils.nim");
					last = (path ? path->Sup.len : 0);
				}
				LA23_: ;
				nimln_(510, "strutils.nim");
				TM_yu6cxgKBBXbNsTkT9cyMd4g_7 = subInt(last, ((NI) 1));
				candidate = copyStrLast(path, first, (NI)(TM_yu6cxgKBBXbNsTkT9cyMd4g_7));
				nimln_(157, "os.nim");
				T25_ = (NimStringDesc*)0;
				T25_ = expandTilde_DOCYVvghSr9cSjyIq0voF3g(candidate);
				x = slash__lXoMhn1ZYc9cAJa9bfA61msg(T25_, exe);
				{
					NimStringDesc* ext_2;
					NI i_2;
					ext_2 = (NimStringDesc*)0;
					nimln_(2185, "system.nim");
					i_2 = ((NI) 0);
					{
						nimln_(2186, "system.nim");
						while (1) {
							NimStringDesc* x_2;
							NI TM_yu6cxgKBBXbNsTkT9cyMd4g_9;
							if (!(i_2 < extensionsLen_0)) goto LA28;
							nimln_(2187, "system.nim");
							if ((NU)(i_2) >= (NU)(extensionsLen_0)) raiseIndexError();
							ext_2 = extensions[i_2];
							nimln_(159, "os.nim");
							x_2 = nosaddFileExt(x, ext_2);
							nimln_(160, "os.nim");
							{
								NIM_BOOL T31_;
								T31_ = (NIM_BOOL)0;
								T31_ = nosexistsFile(x_2);
								if (!T31_) goto LA32_;
								{
									nimln_(162, "os.nim");
									while (1) {
										if (!followSymlinks) goto LA35;
										nimln_(163, "os.nim");
										{
											NIM_BOOL T38_;
											NimStringDesc* r;
											NI len;
											T38_ = (NIM_BOOL)0;
											T38_ = checkSymlink_KkZgXPy74tXi49bh8QSie8g(x_2);
											if (!T38_) goto LA39_;
											nimln_(164, "os.nim");
											r = mnewString(((NI) 256));
											nimln_(165, "os.nim");
											len = readlink(x_2->data, r->data, ((NI) 256));
											nimln_(166, "os.nim");
											{
												NI32 T45_;
												if (!(len < ((NI) 0))) goto LA43_;
												nimln_(167, "os.nim");
												T45_ = (NI32)0;
												T45_ = osLastError_tNPXXFl9cb3BG0pJKzUn9bew();
												raiseOSError_bEwAamo1N7TKcaU9akpiyIg(T45_, ((NimStringDesc*) &TM_yu6cxgKBBXbNsTkT9cyMd4g_5));
											}
											LA43_: ;
											nimln_(168, "os.nim");
											{
												NI TM_yu6cxgKBBXbNsTkT9cyMd4g_8;
												if (!(((NI) 256) < len)) goto LA48_;
												nimln_(169, "os.nim");
												TM_yu6cxgKBBXbNsTkT9cyMd4g_8 = addInt(len, ((NI) 1));
												r = mnewString(((NI)chckRange((NI)(TM_yu6cxgKBBXbNsTkT9cyMd4g_8), ((NI) 0), ((NI) IL64(9223372036854775807)))));
												nimln_(170, "os.nim");
												len = readlink(x_2->data, r->data, len);
											}
											LA48_: ;
											nimln_(171, "os.nim");
											r = setLengthStr(r, ((NI)chckRange(len, ((NI) 0), ((NI) IL64(9223372036854775807)))));
											nimln_(172, "os.nim");
											{
												NIM_BOOL T52_;
												T52_ = (NIM_BOOL)0;
												T52_ = nosisAbsolute(r);
												if (!T52_) goto LA53_;
												nimln_(173, "os.nim");
												x_2 = copyString(r);
											}
											goto LA50_;
											LA53_: ;
											{
												NimStringDesc* T56_;
												nimln_(175, "os.nim");
												T56_ = (NimStringDesc*)0;
												T56_ = nosparentDir(x_2);
												x_2 = slash__lXoMhn1ZYc9cAJa9bfA61msg(T56_, r);
											}
											LA50_: ;
										}
										goto LA36_;
										LA39_: ;
										{
											nimln_(177, "os.nim");
											goto LA34;
										}
										LA36_: ;
									} LA35: ;
								} LA34: ;
								nimln_(178, "os.nim");
								result = copyString(x_2);
								goto BeforeRet_;
							}
							LA32_: ;
							nimln_(2188, "system.nim");
							TM_yu6cxgKBBXbNsTkT9cyMd4g_9 = addInt(i_2, ((NI) 1));
							i_2 = (NI)(TM_yu6cxgKBBXbNsTkT9cyMd4g_9);
						} LA28: ;
					}
				}
				nimln_(511, "strutils.nim");
				{
					if (!(splits == ((NI) 0))) goto LA60_;
					goto LA15;
				}
				LA60_: ;
				nimln_(512, "strutils.nim");
				TM_yu6cxgKBBXbNsTkT9cyMd4g_10 = subInt(splits, ((NI) 1));
				splits = (NI)(TM_yu6cxgKBBXbNsTkT9cyMd4g_10);
				nimln_(513, "strutils.nim");
				TM_yu6cxgKBBXbNsTkT9cyMd4g_11 = addInt(last, ((NI) 1));
				last = (NI)(TM_yu6cxgKBBXbNsTkT9cyMd4g_11);
			} LA16: ;
		} LA15: ;
	}
	nimln_(179, "os.nim");
	result = copyString(((NimStringDesc*) &TM_yu6cxgKBBXbNsTkT9cyMd4g_5));
	}BeforeRet_: ;
	popFrame();
	return result;
}
NIM_EXTERNC N_NOINLINE(void, stdlib_osInit000)(void) {
	nimfr_("os", "os.nim");
	popFrame();
}

NIM_EXTERNC N_NOINLINE(void, stdlib_osDatInit000)(void) {
}

