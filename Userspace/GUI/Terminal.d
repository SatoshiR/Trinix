module Userspace.GUI.Terminal;

import System.IFace;
import System.ResourceCaller;

import System.IO.FileStream;
import System.Diagnostics.ProcessStartInfo;
import System.Diagnostics.Process;


class Terminal {
	public static long Main(string[] args) {
		ulong m, s;
		ResourceCaller.StaticCall(IFace.FSNode.OBJECT, [IFace.FSNode.CREATETTY, cast(ulong)&m, cast(ulong)&s]);
		auto master = new FileStream(m);
		auto slave = new FileStream(s);

		auto startInfo = new ProcessStartInfo();
		startInfo.ThreadEntry = &test;
		Process.Start(startInfo);
		return 0;
	}
}


long construct(ulong* pointer) {
	string[] args = (cast(string *)pointer[0])[0 .. pointer[1]];
	return Terminal.Main(args);
}


//new process
long test(ulong* pnt) {
	ResourceCaller.StaticCall(IFace.FSNode.OBJECT, [0x123]);
	return 0;
}

long test2(ulong* pnt) {
	ResourceCaller.StaticCall(IFace.FSNode.OBJECT, [0x456]);
	return 0;
}

long test3(ulong* pnt) {
	ResourceCaller.StaticCall(IFace.FSNode.OBJECT, [0x789]);
	return 0;
}