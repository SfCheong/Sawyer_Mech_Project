classdef Signals < handle
    %SIGNAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj= Signals()
            obj.functions	= WeakSet();
            obj.methods     = WeakKeyDictionary();
        end

    function __call__(self, *args, **kargs)
        for f = obj.functions
            f(*args, **kargs)
        end

        for obj, functions = obj.methods.items()
            for f = functions
                f(obj, *args, **kargs)
            end
        end
    end

    function connect(self, slot)        
        if inspect.ismethod(slot)
            if not slot.__self__ in obj.methods
                obj.methods[slot.__self__] = set()
            end
            obj.methods[slot.__self__].add(slot.__func__)            
        else
            obj.functions.add(slot)
        end

    function disconnect(self, slot)
        if inspect.ismethod(slot)
            if slot.__self__ in obj.methods
                obj.methods[slot.__self__].remove(slot.__func__)
            end
        else
            if slot in obj.functions
                obj.functions.remove(slot)
            end
        end
    end
    
end

