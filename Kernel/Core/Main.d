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
import SyscallManager.Res;
import TaskManager.Task;

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
	dorobit IDT

	Dorobit heap & delete!!
	Az potom VFS a syscall mgr
	dorobit string
	Panic - vypis Rx registrov, inak vsetko O.K.
	dorobit pipeDev, opravit, task switch
	dorobit Serialdev, inak vsetko funguje
	timer - wakeup and task switch
	Res - resources list...
++/

extern(C) void StartSystem() {
	Log.Init();
	//For debug print malloc and free
	//Memory.test = 123456789;
	Log.Print("Initializing Architecture: x86_64");
	Architecture.Init();

	Log.Print("Initializing Physical Memory & Paging");
	PhysMem.Init();

	Log.Print("Initializing CPU");
	CPU.Init();

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

	//Log.Print("Initializing VGA text output driver");
	//VGATextOutput textOutput = new VGATextOutput();
	//Log.Result(true);

	Log.Print("Init complete, starting terminal");
	Log.Result(false);


	//setup display mode
	//Display.SetMode(textOutput.GetModes()[0]);

	//import Devices.Mouse.PS2Mouse;
	//new PS2Mouse(); need to fix...

	VFS.PrintTree(VFS.Root);


	import TaskManager.Thread;
	auto t = new Thread(cast(void function())&test);

	import SyscallManager.Syscall;
	//Syscall.Init();



	/*asm {
		mov RAX, 0x123;
		mov RBX, 0x456;
		mov RCX, 0x789;
		mov RDX, 0xABC;
		mov R8, 0xDEF;

		syscall;
//		syscall;
//		syscall;
	}*/



	while (true) {}
}


extern(C) void test() {
	while (true) asm { int 28; }
}