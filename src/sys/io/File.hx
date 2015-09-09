package sys.io;

import js.node.Fs;

@:dce
@:coreApi
class File {

	public static inline function getContent( path : String ) : String {
		return Fs.readFileSync(path, {encoding: "utf8"});
	}

	public static inline function saveContent( path : String, content : String ) : Void {
		Fs.writeFileSync(path, content);
	}

	public static inline function getBytes( path : String ) : haxe.io.Bytes {
		return haxe.io.Bytes.ofData(Fs.readFileSync(path));
	}

	public static inline function saveBytes( path : String, bytes : haxe.io.Bytes ) : Void {
		Fs.writeFileSync(path, bytes.getData());
	}

	static inline var copyBufLen = 64 * 1024;
	static var copyBuf = new js.node.Buffer(copyBufLen);

	public static function copy( srcPath : String, dstPath : String ) : Void {
		var src = Fs.openSync(srcPath, Read);
		var stat = Fs.fstatSync(src);
		var dst = Fs.openSync(dstPath, WriteCreate, stat.mode);
		var bytesRead, pos = 0;
		while ((bytesRead = Fs.readSync(src, copyBuf, 0, copyBufLen, pos)) > 0) {
			Fs.writeSync(dst, copyBuf, 0, bytesRead);
			pos += bytesRead;
		}
		Fs.closeSync(src);
		Fs.closeSync(dst);
	}
}