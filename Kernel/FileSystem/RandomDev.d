module FileSystem.RandomDev;

import VFSManager.CharNode;
import VFSManager.DirectoryNode;
import Devices.Random;


class RandomDev : CharNode {
	this(string name = "random") { 
		super(name);
		length = 1024;
	}

	override ulong Read(ulong offset, byte[] data) {
		foreach (ref x; data)
			x = Random.Number & 0xFF;

		return data.length;
	}

	override ulong Write(ulong offset, byte[] data) {
		return data.length;
	}
}