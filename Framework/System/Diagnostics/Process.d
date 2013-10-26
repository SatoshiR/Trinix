module System.Diagnostics.Process;

import System.IFace;
import System.ResourceCaller;

import System.Diagnostics.ProcessStartInfo;


enum SigNum {
	SIGHUP = 1, /* Hangup */
	SIGINT,     /* Interupt */
	SIGQUIT,    /* Quit */
	SIGILL,     /* Illegal instruction */
	SIGTRAP,    /* A breakpoint or trace instruction has been reached */
	SIGABRT,    /* Another process has requested that you abort */
	SIGEMT,     /* Emulation trap XXX */
	SIGFPE,     /* Floating-point arithmetic exception */
	SIGKILL,    /* You have been stabbed repeated with a large knife */
	SIGBUS,     /* Bus error (device error) */
	SIGSEGV,    /* Segmentation fault */
	SIGSYS,     /* Bad system call */
	SIGPIPE,    /* Attempted to read or write from a broken pipe */
	SIGALRM,    /* This is your wakeup call. */
	SIGTERM,    /* You have been Schwarzenegger'd */
	SIGUSR1,    /* User Defined Signal #1 */
	SIGUSR2,    /* User Defined Signal #2 */
	SIGCHLD,    /* Child status report */
	SIGPWR,     /* We need moar powah! */
	SIGWINCH,   /* Your containing terminal has changed size */
	SIGURG,     /* An URGENT! event (On a socket) */
	SIGPOLL,    /* XXX OBSOLETE; socket i/o possible */
	SIGSTOP,    /* Stopped (signal) */
	SIGTSTP,    /* ^Z (suspend) */
	SIGCONT,    /* Unsuspended (please, continue) */
	SIGTTIN,    /* TTY input has stopped */
	SIGTTOUT,   /* TTY output has stopped */
	SIGVTALRM,  /* Virtual timer has expired */
	SIGPROF,    /* Profiling timer expired */
	SIGXCPU,    /* CPU time limit exceeded */
	SIGXFSZ,    /* File size limit exceeded */
	SIGWAITING, /* Herp */
	SIGDIAF,    /* Die in a fire */
	SIGHATE,    /* The sending process does not like you */
	SIGWINEVENT, /* Window server event */
	SIGCAT,     /* Everybody loves cats */

	SIGTTOU
}


class Process {
private:
	ResourceCaller syscall;


public:
	static Process Start(ProcessStartInfo startInfo) {
		return new Process(ResourceCaller.StaticCall(IFace.Process.OBJECT, [IFace.Process.S_CREATE, cast(ulong)&startInfo]));
	}

	static @property Process Current() {
		return new Process(ResourceCaller.StaticCall(IFace.Process.OBJECT, [IFace.Process.CURRENT]));
	}

	ulong ResID() { return syscall.ResID(); }

	this(ulong id) {
		syscall = new ResourceCaller(id, IFace.Process.OBJECT);
	}

	void SetSingalHanlder(SigNum signal, void delegate() hanlder) {
		syscall.Call(IFace.Process.SET_HANDLER, [signal, cast(ulong)&hanlder]);
	}

	void SendSignal(SigNum signal) {
		syscall.Call(IFace.Process.SEND_SIGNAL, [signal]);
	}
}