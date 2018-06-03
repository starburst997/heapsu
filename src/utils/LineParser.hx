package utils;

import haxe.ds.Option;

using FS;

class LinePointer {
    public var index:Int = 0;
    public static inline function create() { return new LinePointer(); }
    public function new() { }
}

class LineParser<T> {
    
    var pointer:LinePointer;
    var lines:Array<String>;
    var mapper:String->T;
    var validator:Option<String->Bool> = None;
    var formatter:Option<String->String> = None;
    var breaker:Option<String->Bool> = None;

    public static inline function create(str) {
        return new LineParser(str);
    }

    public function new(?str:String, ?pointer:LinePointer, ?mapper:String->T) {
        str.ifExists(str -> {
            lines = str.split('\n');
        });

        this.pointer = pointer.getOr(() -> LinePointer.create());
        this.mapper = mapper.getOr(() -> cast(line -> line));
    }

    public inline function clone<K>(?mapper:String->K):LineParser<K> {
        var parser = new LineParser(pointer, mapper);
        parser.lines = lines;
        parser.validator = validator;
        parser.formatter = formatter;
        parser.breaker = breaker;
        return parser;
    }

    public inline function readLine():T {
        var line = lines[pointer.index++];
        var formattedLine = (switch(formatter) {
            case None : line;
            case Some(f) : f(line);
        });

        return mapper(formattedLine);
    }

    public inline function setValidator(f:String->Bool) {
        validator = f.toOption();
        return this;
    }

    public inline function setFormatter(f:String->String) {
        formatter = f.toOption();
        return this;
    }

    public function setBreaker(f:String->Bool) {
        breaker = f.toOption();
        return this;
    }

    public function hasNext() {
        return switch(validator) {
            case None if (breaker.isNone()) : pointer.index < lines.length;
            default : 
                var b = breaker.getOr(() -> (line -> false));
                var v = validator.getOr(() -> (line -> true));

                while(pointer.index < lines.length) {
                    var line = lines[pointer.index];
                    if (b(line)) return false;
                    if (v(line)) break;
                    pointer.index++;
                }
                pointer.index < lines.length;
        }
    }

    public function next() {
        return readLine();
    }

    public function iterator() {
        return this;
    }
}