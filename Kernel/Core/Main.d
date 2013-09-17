module Core.Main;

import Core.Log;
import Core.DeviceManager;
import MemoryManager.Memory;
import MemoryManager.PageAllocator;
import MemoryManager.PhysMem;
import MemoryManager.Heap;

import Architectures.Multiprocessor;
import Architectures.Paging;
import Architectures.Main;
import Architectures.CPU;

import VFSManager.VFS;
import TaskManager.Task;
import SyscallManager.Res;
import SyscallManager.Syscall;

import Devices.Timer;
import Devices.Keyboard.PS2Keyboard;
import Devices.Display.VGATextOutput;

/++
Framework:
	BitArray
	Mutex
	-Wchar atd.
	Color - FromKnownColor name, ToUpper...
	convert - prerobit na vlastny string bez alloc
	list - search a delete

System:
	MP
	Dorobit heap & delete!!
	Az potom VFS a syscall mgr
	dorobit string
	Panic - vypis Rx registrov, inak vsetko O.K.
	Res - resources list...
	syscall handler
	implementovat user permissions z VFSka
++/

import FileSystem.PipeDev;
__gshared PipeDev pajpa;


extern(C) void StartSystem() {
	Log.Init();

	//For debug print malloc and free
	//Memory.test = 123456789;
	Log.Print("Initializing Architecture: x86_64");
	Architecture.Init();

	Log.Print("Initializing CPU");
	CPU.Init();

	Log.Print("Initializing Physical Memory & Paging");
	PhysMem.Init();

	Log.Print("Initializing kernel heap");

	//Memory.KernelHeap = new Heap();
	//Memory.KernelHeap.Create(cast(ulong)PageAllocator.AllocPage(), Heap.MIN_SIZE, 0x10000, Paging.KernelPaging);
	//PageAllocator.IsInit = true;
	Log.Result(false);

	Log.Print("Initializing Multiprocessor configuration");
	Log.Result(Multiprocessor.Init());

	Log.Print("Starting multiple cores");
	Log.Result(true);
	Multiprocessor.BootCores();

//==================== MANAGERS ====================
	Log.Print("Initializing system calls database");
	Log.Result(Res.Init());

	Log.Print("Initializing syscall handler");
	Log.Result(Syscall.Init());

	Log.Print("Initializing device manger");
	Log.Result(DeviceManager.Init());

	Log.Print("Initializing VFS manger");
	Log.Result(VFS.Init());

	Log.Print("Initializing multitasking");
	Log.Result(Task.Init());

//==================== DEVICES ====================
	Log.Print("Initializing timer ticks = 100Hz");
	new Timer(100);
	Log.Result(true);

	Log.Print("Initializing PS/2 keyboard driver");
	//new PS2Keyboard();
	Log.Result(true);

	Log.Print("Init complete, starting terminal");
	Log.Result(false);


	/*pajpa = new PipeDev(0x1000, "pajpa");

	import TaskManager.Thread;
	auto t = new Thread(cast(void function())&test);
	t.Start();

	import VFSManager.PipeNode;
	import System.Convert;

	byte[] tmp = new byte[1];
	while (true) {
		pajpa.Read(0, tmp);
		Log.PrintSP("\ntest: " ~ Convert.ToString(tmp[0]));
		tmp[0] = 0;
	}*/

	VFS.PrintTree(VFS.Root);

	while (true) {}
}

extern(C) void apEntry() {
	while (true) { }
}

extern(C) void test() {
//	while (true) pajpa.Write(0, ['x']);
//	Log.PrintSP("a");
	//asm {naked; int 6;}
	//asm {naked; push RAX;}
	//asm { syscall; }
	while (true) { }
}

/* DEPRECATED:
	//Log.Print("Initializing VGA text output driver");
	//VGATextOutput textOutput = new VGATextOutput();
	//Log.Result(true);

	//setup display mode
	//Display.SetMode(textOutput.GetModes()[0]);

	//import Devices.Mouse.PS2Mouse;
	//new PS2Mouse(); need to fix...
*/




/*
	struct aast {
		int a;
		int b;
		int c;
	}

	aast struktura;
	struktura.a = 5;
	struktura.b = 10;
	struktura.c = 56;

	PrintStruct(struktura);



void PrintStruct(T)(ref T s, bool recursive = false, ulong indent = 0) {
	void tabs() {
		for(ulong i = 0; i < indent; i++)
			Log.Print("\t");
	}

	alias FieldNames!(T) fieldNames;

	tabs();
	indent++;

	kprintfln!(T.stringof ~ " ({})")(&s, false);

	foreach(i, _; s.tupleof) {
		static if(is(typeof(s.tupleof[i]) == struct) ||
			(isPointerType!(typeof(s.tupleof[i])) && is(typeof(*s.tupleof[i]) == struct))) {
			tabs();

			if(recursive) {
				putstr(fieldNames[i]);
				putstr(": ");

				static if(isPointerType!(typeof(s.tupleof[i]))) {
					if(s.tupleof[i] is null)
						putstr("(null)\n");
					else {
						putchar('\n');
						printStruct(*s.tupleof[i], true, indent, false);
					}
				} else {
					putchar('\n');
					printStruct(s.tupleof[i], true, indent, false);
				}
			} else {
				static if(isPointerType!(typeof(s.tupleof[i]))) {
					kprintfln!(fieldNames[i] ~ " = {x}")(s.tupleof[i], false);
				} else {
					kprintfln!(fieldType.stringof ~ " " ~ fieldNames[i] ~ " (struct)", false);
				}
			}
		} else {
			tabs();

			static if(isIntType!(typeof(s.tupleof[i]))) {
				kprintfln!(fieldNames[i] ~ " = 0x{x}")(s.tupleof[i], false);
			} else {
				kprintfln!(fieldNames[i] ~ " = {}")(s.tupleof[i], false);
			}
		}
	}
}*/