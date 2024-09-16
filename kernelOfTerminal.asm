std::piecewise_construct:
        .zero   1
filesystem[abi:cxx11]:
        .zero   48
File::~File() [base object destructor]:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     QWORD PTR [rbp-8], rdi
        mov     rax, QWORD PTR [rbp-8]
        add     rax, 32
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
        mov     rax, QWORD PTR [rbp-8]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
        nop
        leave
        ret
File::operator=(File&&):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     QWORD PTR [rbp-8], rdi
        mov     QWORD PTR [rbp-16], rsi
        mov     rdx, QWORD PTR [rbp-16]
        mov     rax, QWORD PTR [rbp-8]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::operator=(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&&)
        mov     rax, QWORD PTR [rbp-16]
        lea     rdx, [rax+32]
        mov     rax, QWORD PTR [rbp-8]
        add     rax, 32
        mov     rsi, rdx
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::operator=(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&&)
        mov     rax, QWORD PTR [rbp-8]
        leave
        ret
.LC0:
        .string "\320\244\320\260\320\271\320\273 \321\203\320\266\320\265 \321\201\321\203\321\211\320\265\321\201\321\202\320\262\321\203\320\265\321\202: "
.LC1:
        .string ""
.LC2:
        .string "\320\244\320\260\320\271\320\273 \321\201\320\276\320\267\320\264\320\260\320\275: "
create_file(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&):
        push    rbp
        mov     rbp, rsp
        push    r12
        push    rbx
        sub     rsp, 112
        mov     QWORD PTR [rbp-120], rdi
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::end()
        mov     QWORD PTR [rbp-112], rax
        mov     rax, QWORD PTR [rbp-120]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::find(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     QWORD PTR [rbp-104], rax
        lea     rdx, [rbp-112]
        lea     rax, [rbp-104]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::operator!=(std::_Rb_tree_iterator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > const&, std::_Rb_tree_iterator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > const&)
        test    al, al
        je      .L28
        mov     esi, OFFSET FLAT:.LC0
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-120]
        mov     rsi, rax
        mov     rdi, rdx
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <char, std::char_traits<char>, std::allocator<char> >(std::basic_ostream<char, std::char_traits<char> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(std::basic_ostream<char, std::char_traits<char> >& (*)(std::basic_ostream<char, std::char_traits<char> >&))
        jmp     .L27
.L28:
        mov     rdx, QWORD PTR [rbp-120]
        lea     rax, [rbp-96]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [complete object constructor]
        mov     r12d, 1
        lea     rax, [rbp-25]
        mov     QWORD PTR [rbp-24], rax
        nop
        nop
        lea     rax, [rbp-25]
        lea     rdx, [rbp-96]
        lea     rcx, [rdx+32]
        mov     rdx, rax
        mov     esi, OFFSET FLAT:.LC1
        mov     rdi, rcx
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string<std::allocator<char> >(char const*, std::allocator<char> const&)
        mov     r12d, 0
        mov     rax, QWORD PTR [rbp-120]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::operator[](std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     rdx, rax
        lea     rax, [rbp-96]
        mov     rsi, rax
        mov     rdi, rdx
        call    File::operator=(File&&)
        lea     rax, [rbp-96]
        mov     rdi, rax
        call    File::~File() [complete object destructor]
        lea     rax, [rbp-25]
        mov     rdi, rax
        call    std::__new_allocator<char>::~__new_allocator() [base object destructor]
        nop
        mov     esi, OFFSET FLAT:.LC2
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-120]
        mov     rsi, rax
        mov     rdi, rdx
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <char, std::char_traits<char>, std::allocator<char> >(std::basic_ostream<char, std::char_traits<char> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(std::basic_ostream<char, std::char_traits<char> >& (*)(std::basic_ostream<char, std::char_traits<char> >&))
        jmp     .L27
        mov     rbx, rax
        lea     rax, [rbp-96]
        mov     rdi, rax
        call    File::~File() [complete object destructor]
        jmp     .L31
        mov     rbx, rax
.L31:
        lea     rax, [rbp-25]
        mov     rdi, rax
        call    std::__new_allocator<char>::~__new_allocator() [base object destructor]
        nop
        test    r12b, r12b
        je      .L32
        lea     rax, [rbp-96]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
.L32:
        mov     rax, rbx
        mov     rdi, rax
        call    _Unwind_Resume
.L27:
        add     rsp, 112
        pop     rbx
        pop     r12
        pop     rbp
        ret
.LC3:
        .string "\320\244\320\260\320\271\320\273 \320\275\320\265 \320\275\320\260\320\271\320\264\320\265\320\275: "
.LC4:
        .string "\320\244\320\260\320\271\320\273 \321\203\320\264\320\260\320\273\320\265\320\275: "
delete_file(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD PTR [rbp-24], rdi
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::end()
        mov     QWORD PTR [rbp-16], rax
        mov     rax, QWORD PTR [rbp-24]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::find(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     QWORD PTR [rbp-8], rax
        lea     rdx, [rbp-16]
        lea     rax, [rbp-8]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::operator==(std::_Rb_tree_iterator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > const&, std::_Rb_tree_iterator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > const&)
        test    al, al
        je      .L36
        mov     esi, OFFSET FLAT:.LC3
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-24]
        mov     rsi, rax
        mov     rdi, rdx
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <char, std::char_traits<char>, std::allocator<char> >(std::basic_ostream<char, std::char_traits<char> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(std::basic_ostream<char, std::char_traits<char> >& (*)(std::basic_ostream<char, std::char_traits<char> >&))
        jmp     .L35
.L36:
        mov     rax, QWORD PTR [rbp-24]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::erase(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:.LC4
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-24]
        mov     rsi, rax
        mov     rdi, rdx
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <char, std::char_traits<char>, std::allocator<char> >(std::basic_ostream<char, std::char_traits<char> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(std::basic_ostream<char, std::char_traits<char> >& (*)(std::basic_ostream<char, std::char_traits<char> >&))
.L35:
        leave
        ret
.LC5:
        .string "\320\241\320\276\320\264\320\265\321\200\320\266\320\270\320\274\320\276\320\265 \321\204\320\260\320\271\320\273\320\260 "
.LC6:
        .string ":\n"
read_file(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&):
        push    rbp
        mov     rbp, rsp
        push    rbx
        sub     rsp, 40
        mov     QWORD PTR [rbp-40], rdi
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::end()
        mov     QWORD PTR [rbp-32], rax
        mov     rax, QWORD PTR [rbp-40]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::find(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     QWORD PTR [rbp-24], rax
        lea     rdx, [rbp-32]
        lea     rax, [rbp-24]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::operator==(std::_Rb_tree_iterator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > const&, std::_Rb_tree_iterator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > const&)
        test    al, al
        je      .L39
        mov     esi, OFFSET FLAT:.LC3
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-40]
        mov     rsi, rax
        mov     rdi, rdx
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <char, std::char_traits<char>, std::allocator<char> >(std::basic_ostream<char, std::char_traits<char> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(std::basic_ostream<char, std::char_traits<char> >& (*)(std::basic_ostream<char, std::char_traits<char> >&))
        jmp     .L38
.L39:
        mov     esi, OFFSET FLAT:.LC5
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-40]
        mov     rsi, rax
        mov     rdi, rdx
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <char, std::char_traits<char>, std::allocator<char> >(std::basic_ostream<char, std::char_traits<char> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:.LC6
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     rbx, rax
        mov     rax, QWORD PTR [rbp-40]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::operator[](std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        add     rax, 32
        mov     rsi, rax
        mov     rdi, rbx
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <char, std::char_traits<char>, std::allocator<char> >(std::basic_ostream<char, std::char_traits<char> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(std::basic_ostream<char, std::char_traits<char> >& (*)(std::basic_ostream<char, std::char_traits<char> >&))
.L38:
        mov     rbx, QWORD PTR [rbp-8]
        leave
        ret
.LC7:
        .string "\320\244\320\260\320\271\320\273 "
.LC8:
        .string " \320\276\320\261\320\275\320\276\320\262\320\273\320\265\320\275."
write_file(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD PTR [rbp-24], rdi
        mov     QWORD PTR [rbp-32], rsi
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::end()
        mov     QWORD PTR [rbp-16], rax
        mov     rax, QWORD PTR [rbp-24]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::find(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     QWORD PTR [rbp-8], rax
        lea     rdx, [rbp-16]
        lea     rax, [rbp-8]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::operator==(std::_Rb_tree_iterator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > const&, std::_Rb_tree_iterator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > const&)
        test    al, al
        je      .L42
        mov     esi, OFFSET FLAT:.LC3
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-24]
        mov     rsi, rax
        mov     rdi, rdx
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <char, std::char_traits<char>, std::allocator<char> >(std::basic_ostream<char, std::char_traits<char> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(std::basic_ostream<char, std::char_traits<char> >& (*)(std::basic_ostream<char, std::char_traits<char> >&))
        jmp     .L41
.L42:
        mov     rax, QWORD PTR [rbp-24]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::operator[](std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        lea     rdx, [rax+32]
        mov     rax, QWORD PTR [rbp-32]
        mov     rsi, rax
        mov     rdi, rdx
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::operator=(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:.LC7
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-24]
        mov     rsi, rax
        mov     rdi, rdx
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <char, std::char_traits<char>, std::allocator<char> >(std::basic_ostream<char, std::char_traits<char> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        mov     esi, OFFSET FLAT:.LC8
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(std::basic_ostream<char, std::char_traits<char> >& (*)(std::basic_ostream<char, std::char_traits<char> >&))
.L41:
        leave
        ret
.LC9:
        .string "\320\235\320\265\320\262\320\265\321\200\320\275\320\260\321\217 \320\272\320\276\320\274\320\260\320\275\320\264\320\260."
.LC10:
        .string "create"
.LC11:
        .string "delete"
.LC12:
        .string "read"
.LC13:
        .string "write"
.LC14:
        .string " "
process_command(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&):
        push    rbp
        mov     rbp, rsp
        push    rbx
        sub     rsp, 200
        mov     QWORD PTR [rbp-200], rdi
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::vector() [complete object constructor]
        lea     rax, [rbp-144]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string() [complete object constructor]
        mov     rax, QWORD PTR [rbp-200]
        mov     QWORD PTR [rbp-32], rax
        mov     rax, QWORD PTR [rbp-32]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::begin() const
        mov     QWORD PTR [rbp-152], rax
        mov     rax, QWORD PTR [rbp-32]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::end() const
        mov     QWORD PTR [rbp-160], rax
        jmp     .L48
.L51:
        lea     rax, [rbp-152]
        mov     rdi, rax
        call    __gnu_cxx::__normal_iterator<char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >::operator*() const
        movzx   eax, BYTE PTR [rax]
        mov     BYTE PTR [rbp-33], al
        cmp     BYTE PTR [rbp-33], 32
        jne     .L49
        lea     rax, [rbp-144]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::empty() const
        xor     eax, 1
        test    al, al
        je      .L50
        lea     rdx, [rbp-144]
        lea     rax, [rbp-112]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::push_back(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        lea     rax, [rbp-144]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::clear()
        jmp     .L50
.L49:
        movsx   edx, BYTE PTR [rbp-33]
        lea     rax, [rbp-144]
        mov     esi, edx
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::operator+=(char)
.L50:
        lea     rax, [rbp-152]
        mov     rdi, rax
        call    __gnu_cxx::__normal_iterator<char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >::operator++()
.L48:
        lea     rdx, [rbp-160]
        lea     rax, [rbp-152]
        mov     rsi, rdx
        mov     rdi, rax
        call    bool __gnu_cxx::operator!=<char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >(__gnu_cxx::__normal_iterator<char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > const&, __gnu_cxx::__normal_iterator<char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > const&)
        test    al, al
        jne     .L51
        lea     rax, [rbp-144]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::empty() const
        xor     eax, 1
        test    al, al
        je      .L52
        lea     rdx, [rbp-144]
        lea     rax, [rbp-112]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::push_back(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
.L52:
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::empty() const
        test    al, al
        je      .L53
        mov     esi, OFFSET FLAT:.LC9
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(std::basic_ostream<char, std::char_traits<char> >& (*)(std::basic_ostream<char, std::char_traits<char> >&))
        mov     ebx, 0
        jmp     .L54
.L53:
        lea     rax, [rbp-112]
        mov     esi, 0
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::operator[](unsigned long)
        mov     esi, OFFSET FLAT:.LC10
        mov     rdi, rax
        call    bool std::operator==<char, std::char_traits<char>, std::allocator<char> >(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, char const*)
        test    al, al
        je      .L55
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::size() const
        cmp     rax, 2
        jne     .L55
        mov     eax, 1
        jmp     .L56
.L55:
        mov     eax, 0
.L56:
        test    al, al
        je      .L57
        lea     rax, [rbp-112]
        mov     esi, 1
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::operator[](unsigned long)
        mov     rdi, rax
        call    create_file(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        jmp     .L58
.L57:
        lea     rax, [rbp-112]
        mov     esi, 0
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::operator[](unsigned long)
        mov     esi, OFFSET FLAT:.LC11
        mov     rdi, rax
        call    bool std::operator==<char, std::char_traits<char>, std::allocator<char> >(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, char const*)
        test    al, al
        je      .L59
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::size() const
        cmp     rax, 2
        jne     .L59
        mov     eax, 1
        jmp     .L60
.L59:
        mov     eax, 0
.L60:
        test    al, al
        je      .L61
        lea     rax, [rbp-112]
        mov     esi, 1
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::operator[](unsigned long)
        mov     rdi, rax
        call    delete_file(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        jmp     .L58
.L61:
        lea     rax, [rbp-112]
        mov     esi, 0
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::operator[](unsigned long)
        mov     esi, OFFSET FLAT:.LC12
        mov     rdi, rax
        call    bool std::operator==<char, std::char_traits<char>, std::allocator<char> >(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, char const*)
        test    al, al
        je      .L62
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::size() const
        cmp     rax, 2
        jne     .L62
        mov     eax, 1
        jmp     .L63
.L62:
        mov     eax, 0
.L63:
        test    al, al
        je      .L64
        lea     rax, [rbp-112]
        mov     esi, 1
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::operator[](unsigned long)
        mov     rdi, rax
        call    read_file(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        jmp     .L58
.L64:
        lea     rax, [rbp-112]
        mov     esi, 0
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::operator[](unsigned long)
        mov     esi, OFFSET FLAT:.LC13
        mov     rdi, rax
        call    bool std::operator==<char, std::char_traits<char>, std::allocator<char> >(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, char const*)
        test    al, al
        je      .L65
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::size() const
        cmp     rax, 2
        jbe     .L65
        mov     eax, 1
        jmp     .L66
.L65:
        mov     eax, 0
.L66:
        test    al, al
        je      .L67
        lea     rax, [rbp-192]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string() [complete object constructor]
        mov     QWORD PTR [rbp-24], 2
        jmp     .L68
.L69:
        mov     rdx, QWORD PTR [rbp-24]
        lea     rax, [rbp-112]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::operator[](unsigned long)
        mov     rcx, rax
        lea     rax, [rbp-80]
        mov     edx, OFFSET FLAT:.LC14
        mov     rsi, rcx
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > std::operator+<char, std::char_traits<char>, std::allocator<char> >(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, char const*)
        lea     rdx, [rbp-80]
        lea     rax, [rbp-192]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::operator+=(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        lea     rax, [rbp-80]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
        add     QWORD PTR [rbp-24], 1
.L68:
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::size() const
        cmp     QWORD PTR [rbp-24], rax
        setb    al
        test    al, al
        jne     .L69
        lea     rax, [rbp-112]
        mov     esi, 1
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::operator[](unsigned long)
        mov     rdx, rax
        lea     rax, [rbp-192]
        mov     rsi, rax
        mov     rdi, rdx
        call    write_file(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        lea     rax, [rbp-192]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
        jmp     .L58
.L67:
        mov     esi, OFFSET FLAT:.LC9
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
        mov     rdi, rax
        call    std::basic_ostream<char, std::char_traits<char> >::operator<<(std::basic_ostream<char, std::char_traits<char> >& (*)(std::basic_ostream<char, std::char_traits<char> >&))
.L58:
        mov     ebx, 1
.L54:
        lea     rax, [rbp-144]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
        cmp     ebx, 1
        jne     .L70
        mov     ebx, 1
        jmp     .L71
.L70:
        mov     ebx, 0
.L71:
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::~vector() [complete object destructor]
        cmp     ebx, 1
        jmp     .L80
        mov     rbx, rax
        lea     rax, [rbp-80]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
        jmp     .L75
        mov     rbx, rax
.L75:
        lea     rax, [rbp-192]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
        jmp     .L76
        mov     rbx, rax
.L76:
        lea     rax, [rbp-144]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >::~vector() [complete object destructor]
        mov     rax, rbx
        mov     rdi, rax
        call    _Unwind_Resume
.L80:
        mov     rbx, QWORD PTR [rbp-8]
        leave
        ret
.LC15:
        .string "EvaOS> "
.LC16:
        .string "exit"
main:
        push    rbp
        mov     rbp, rsp
        push    rbx
        sub     rsp, 40
        lea     rax, [rbp-48]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string() [complete object constructor]
.L84:
        mov     esi, OFFSET FLAT:.LC15
        mov     edi, OFFSET FLAT:std::cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
        lea     rax, [rbp-48]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:std::cin
        call    std::basic_istream<char, std::char_traits<char> >& std::getline<char, std::char_traits<char>, std::allocator<char> >(std::basic_istream<char, std::char_traits<char> >&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&)
        lea     rax, [rbp-48]
        mov     esi, OFFSET FLAT:.LC16
        mov     rdi, rax
        call    bool std::operator==<char, std::char_traits<char>, std::allocator<char> >(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, char const*)
        test    al, al
        jne     .L90
        lea     rax, [rbp-48]
        mov     rdi, rax
        call    process_command(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)
        jmp     .L84
.L90:
        nop
        mov     ebx, 0
        lea     rax, [rbp-48]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
        mov     eax, ebx
        jmp     .L89
        mov     rbx, rax
        lea     rax, [rbp-48]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::~basic_string() [complete object destructor]
        mov     rax, rbx
        mov     rdi, rax
        call    _Unwind_Resume
.L89:
        mov     rbx, QWORD PTR [rbp-8]
        leave
        ret
.LC17:
        .string "basic_string: construction from null is not valid"
.LC18:
        .string "vector::_M_realloc_append"

File::File() [base object constructor]:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     QWORD PTR [rbp-8], rdi
        mov     rax, QWORD PTR [rbp-8]
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string() [complete object constructor]
        mov     rax, QWORD PTR [rbp-8]
        add     rax, 32
        mov     rdi, rax
        call    std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string() [complete object constructor]
        nop
        leave
        ret
__static_initialization_and_destruction_0():
        push    rbp
        mov     rbp, rsp
        mov     edi, OFFSET FLAT:filesystem[abi:cxx11]
        call    std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::map() [complete object constructor]
        mov     edx, OFFSET FLAT:__dso_handle
        mov     esi, OFFSET FLAT:filesystem[abi:cxx11]
        mov     edi, OFFSET FLAT:std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, File, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, File> > >::~map() [complete object destructor]
        call    __cxa_atexit
        nop
        pop     rbp
        ret
_GLOBAL__sub_I_filesystem[abi:cxx11]:
        push    rbp
        mov     rbp, rsp
        call    __static_initialization_and_destruction_0()
        pop     rbp
        ret