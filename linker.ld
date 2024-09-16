SECTIONS
{
    . = 0x100000; /* Загрузка ядра по адресу 1MB */
    .text : { *(.text) }
    .data : { *(.data) }
    .bss  : { *(.bss) }
}