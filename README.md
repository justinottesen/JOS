# JOS - Justin's Operating System

I am beginning this incredibly ambitious project to learn how operating systems really work. Going
into this project, I have a few years of experience in C, but not much domain specific knowledge.
I took courses on computer architecture and operating systems on the way to my undergrad Computer
Science degree, but the architecture course was focused more on CPU structure, and the operating
system focused more on algorithms, processes, memory, and networking from a higher level. I want
to fill the knowledge gap between these.

A lot of the information I have found so far either assumes a lot of background knowledge, or just
writes the whole thing for you. I do not have the knowledge to do this on my own, but I also don't
want to just copy someone else's code and claim it as my own. If I do that, I don't really get
anything out of it.

If you somehow stumbled upon this looking for a guide, I doubt it will be too helpful. I will keep
track of the references I use, that will probably be the only useful section.

I plan on using this `README` as sort of a journal to document my research and progress. It will
outline my plan, link to the resources I use, and the reasoning behind different decisions I make.
It should be a full summary of everything I did wrong, and how I arrived at the code in the
repository.

## First Steps

I am not completely sure where to start. I know that the BIOS which comes shipped with the hardware
is responsible for starting the bootloader, which in turn is responsible for starting the kernel of
ths OS. My job is to write both of these. I will need to start in assembly, for which I believe my
two real choices are x86 and ARM.

I do not know either of these assembly languages. In school, we used MIPS, a simplified assembly
language. My initial idea was to run my OS on a Raspberry Pi, which appears to run ARM. However,
from some quick searches, it looks like there are fewer resources for someone with my experience,
and x86 at least to start is the right move.

I found the [OSDev](https://wiki.osdev.org) website from my initial searching, so I am starting by
reading the "Introduction - Basic Information" section. Linked in one of the pages is a book called
"[Operating Systems: From 0 to 1](https://github/com/tuhdo/os01/tree/master)", which I am noting
here to save for later in case I feel like I am in over my head. I suppose I expect to be in over
my head, so it really be for if I don't feel confident I can swim back to the surfce through the
manuals.

## The Bootloader

Resources:
- [Bootloader](https://wiki.osdev.org/Bootloader)
- [Boot Sequence](https://wiki.osdev.org/Boot_Sequence)
- [Rolling Your Own Bootloader](https://wiki.osdev.org/Rolling_Your_Own_Bootloader)
- [GRUB](https://wiki.osdev/GRUB)
- [Bare Bones](https://wiki.osdev.org/Bare_Bones)
- [Inside the Linux boot process](https://web.archive.org/web/20190402174801/https://developer.ibm.com/articles/l-linuxboot/)

It looks like I have two choices here. I can either go with an established working bootloader and
get straight to the kernel, or I can write my own. I think for now I will try to write my own, and
if I run into problems, I can fall back to using GRUB.

I will go with a Two-Stage Bootloader, I highly doubt I will be able to fit everything in 512 bytes
to fit in the boot sector. Currently, all I have is a Hello World program.

## Second Stage

Resources:
- [MBR (x86)](https://wiki.osdev.org/MBR_(x86))
- [Memory Map (x86)](https://wiki.osdev.org/Memory_Map_(x86))

Now I need to convert the Hello World bootloader into something that sets up the second stage. I
initially thought I would need to set up a full Master Boot Record (MBR), but it seems that since
I am targeting a floppy disk for now, I don't need to worry about that. I just need to put the
second stage somewhere in another sector.

## Common Resources

- [OSDev](https://wiki.osdev.org)
