" slimv-cljapi.vim:
"               Clojure API lookup support for Slimv
" Version:      0.5.3
" Last Change:  20 May 2009
" Maintainer:   Tamas Kovacs <kovisoft at gmail dot com>
" License:      This file is placed in the public domain.
"               No warranty, express or implied.
"               *** ***   Use At-Your-Own-Risk!   *** ***
"
" =====================================================================
"
"  Load Once:
if &cp || exists( 'g:slimv_cljapi_loaded' )
    finish
endif

let g:slimv_cljapi_loaded = 1

" Root of the Clojure API
if !exists( 'g:slimv_cljapi_root' )
    let g:slimv_cljapi_root = 'http://clojure.org/'
endif
 
if !exists( 'g:slimv_cljapi_db' )
    let g:slimv_cljapi_db = [
    \["def", "special_forms\\#def"],
    \["if", "special_forms\\#if"],
    \["do", "special_forms\\#do"],
    \["let", "special_forms\\#let"],
    \["quote", "special_forms\\#quote"],
    \["var", "special_forms\\#var"],
    \["fn", "special_forms\\#fn"],
    \["loop", "special_forms\\#loop"],
    \["recur", "special_forms\\#recur"],
    \["throw", "special_forms\\#throw"],
    \["try", "special_forms\\#try"],
    \["monitor-enter", "special_forms\\#monitor-enter"],
    \["monitor-exit", "special_forms\\#monitor-exit"],
    \[".", "java_interop\\#dot"],
    \["new", "java_interop\\#new"],
    \["set!", "vars\\#set"],
    \["clojure.core", "api\\#toc1"],
    \["*", "api\\#*"],
    \["*1", "api\\#*1"],
    \["*2", "api\\#*2"],
    \["*3", "api\\#*3"],
    \["*agent*", "api\\#*agent*"],
    \["*clojure-version*", "api\\#*clojure-version*"],
    \["*command-line-args*", "api\\#*command-line-args*"],
    \["*compile-files*", "api\\#*compile-files*"],
    \["*compile-path*", "api\\#*compile-path*"],
    \["*e", "api\\#*e"],
    \["*err*", "api\\#*err*"],
    \["*file*", "api\\#*file*"],
    \["*flush-on-newline*", "api\\#*flush-on-newline*"],
    \["*in*", "api\\#*in*"],
    \["*ns*", "api\\#*ns*"],
    \["*out*", "api\\#*out*"],
    \["*print-dup*", "api\\#*print-dup*"],
    \["*print-length*", "api\\#*print-length*"],
    \["*print-level*", "api\\#*print-level*"],
    \["*print-meta*", "api\\#*print-meta*"],
    \["*print-readably*", "api\\#*print-readably*"],
    \["*read-eval*", "api\\#*read-eval*"],
    \["*warn-on-reflection*", "api\\#*warn-on-reflection*"],
    \["+", "api\\#+"],
    \["-", "api\\#-"],
    \["->", "api\\#->"],
    \["..", "api\\#.."],
    \["/", "api\\#/"],
    \["<", "api\\#<"],
    \["<=", "api\\#<="],
    \["=", "api\\#="],
    \["==", "api\\#=="],
    \[">", "api\\#>"],
    \[">=", "api\\#>="],
    \["accessor", "api\\#accessor"],
    \["aclone", "api\\#aclone"],
    \["add-classpath", "api\\#add-classpath"],
    \["add-watch", "api\\#add-watch"],
    \["add-watcher", "api\\#add-watcher"],
    \["agent", "api\\#agent"],
    \["agent-errors", "api\\#agent-errors"],
    \["aget", "api\\#aget"],
    \["alength", "api\\#alength"],
    \["alias", "api\\#alias"],
    \["all-ns", "api\\#all-ns"],
    \["alter", "api\\#alter"],
    \["alter-meta!", "api\\#alter-meta"],
    \["alter-var-root", "api\\#alter-var-root"],
    \["amap", "api\\#amap"],
    \["ancestors", "api\\#ancestors"],
    \["and", "api\\#and"],
    \["apply", "api\\#apply"],
    \["areduce", "api\\#areduce"],
    \["array-map", "api\\#array-map"],
    \["aset", "api\\#aset"],
    \["aset-boolean", "api\\#aset-boolean"],
    \["aset-byte", "api\\#aset-byte"],
    \["aset-char", "api\\#aset-char"],
    \["aset-double", "api\\#aset-double"],
    \["aset-float", "api\\#aset-float"],
    \["aset-int", "api\\#aset-int"],
    \["aset-long", "api\\#aset-long"],
    \["aset-short", "api\\#aset-short"],
    \["assert", "api\\#assert"],
    \["assoc", "api\\#assoc"],
    \["assoc-in", "api\\#assoc-in"],
    \["associative?", "api\\#associative?"],
    \["atom", "api\\#atom"],
    \["await", "api\\#await"],
    \["await-for", "api\\#await-for"],
    \["bases", "api\\#bases"],
    \["bean", "api\\#bean"],
    \["bigdec", "api\\#bigdec"],
    \["bigint", "api\\#bigint"],
    \["binding", "api\\#binding"],
    \["bit-and", "api\\#bit-and"],
    \["bit-and-not", "api\\#bit-and-not"],
    \["bit-clear", "api\\#bit-clear"],
    \["bit-flip", "api\\#bit-flip"],
    \["bit-not", "api\\#bit-not"],
    \["bit-or", "api\\#bit-or"],
    \["bit-set", "api\\#bit-set"],
    \["bit-shift-left", "api\\#bit-shift-left"],
    \["bit-shift-right", "api\\#bit-shift-right"],
    \["bit-test", "api\\#bit-test"],
    \["bit-xor", "api\\#bit-xor"],
    \["boolean", "api\\#boolean"],
    \["butlast", "api\\#butlast"],
    \["byte", "api\\#byte"],
    \["cast", "api\\#cast"],
    \["char", "api\\#char"],
    \["char-escape-string", "api\\#char-escape-string"],
    \["char-name-string", "api\\#char-name-string"],
    \["class", "api\\#class"],
    \["class?", "api\\#class?"],
    \["clear-agent-errors", "api\\#clear-agent-errors"],
    \["clojure-version", "api\\#clojure-version"],
    \["coll?", "api\\#coll?"],
    \["comment", "api\\#comment"],
    \["commute", "api\\#commute"],
    \["comp", "api\\#comp"],
    \["comparator", "api\\#comparator"],
    \["compare", "api\\#compare"],
    \["compare-and-set!", "api\\#compare-and-set"],
    \["compile", "api\\#compile"],
    \["complement", "api\\#complement"],
    \["concat", "api\\#concat"],
    \["cond", "api\\#cond"],
    \["condp", "api\\#condp"],
    \["conj", "api\\#conj"],
    \["cons", "api\\#cons"],
    \["constantly", "api\\#constantly"],
    \["construct-proxy", "api\\#construct-proxy"],
    \["contains?", "api\\#contains?"],
    \["count", "api\\#count"],
    \["counted?", "api\\#counted?"],
    \["create-ns", "api\\#create-ns"],
    \["create-struct", "api\\#create-struct"],
    \["cycle", "api\\#cycle"],
    \["dec", "api\\#dec"],
    \["decimal?", "api\\#decimal?"],
    \["declare", "api\\#declare"],
    \["definline", "api\\#definline"],
    \["defmacro", "api\\#defmacro"],
    \["defmethod", "api\\#defmethod"],
    \["defmulti", "api\\#defmulti"],
    \["defn", "api\\#defn"],
    \["defn-", "api\\#defn-"],
    \["defonce", "api\\#defonce"],
    \["defstruct", "api\\#defstruct"],
    \["delay", "api\\#delay"],
    \["delay?", "api\\#delay?"],
    \["deref", "api\\#deref"],
    \["derive", "api\\#derive"],
    \["descendants", "api\\#descendants"],
    \["disj", "api\\#disj"],
    \["dissoc", "api\\#dissoc"],
    \["distinct", "api\\#distinct"],
    \["distinct?", "api\\#distinct?"],
    \["doall", "api\\#doall"],
    \["doc", "api\\#doc"],
    \["dorun", "api\\#dorun"],
    \["doseq", "api\\#doseq"],
    \["dosync", "api\\#dosync"],
    \["dotimes", "api\\#dotimes"],
    \["doto", "api\\#doto"],
    \["double", "api\\#double"],
    \["double-array", "api\\#double-array"],
    \["doubles", "api\\#doubles"],
    \["drop", "api\\#drop"],
    \["drop-last", "api\\#drop-last"],
    \["drop-while", "api\\#drop-while"],
    \["empty", "api\\#empty"],
    \["empty?", "api\\#empty?"],
    \["ensure", "api\\#ensure"],
    \["enumeration-seq", "api\\#enumeration-seq"],
    \["eval", "api\\#eval"],
    \["even?", "api\\#even?"],
    \["every?", "api\\#every?"],
    \["false?", "api\\#false?"],
    \["ffirst", "api\\#ffirst"],
    \["file-seq", "api\\#file-seq"],
    \["filter", "api\\#filter"],
    \["find", "api\\#find"],
    \["find-doc", "api\\#find-doc"],
    \["find-ns", "api\\#find-ns"],
    \["find-var", "api\\#find-var"],
    \["first", "api\\#first"],
    \["float", "api\\#float"],
    \["float-array", "api\\#float-array"],
    \["float?", "api\\#float?"],
    \["floats", "api\\#floats"],
    \["flush", "api\\#flush"],
    \["fn", "api\\#fn"],
    \["fn?", "api\\#fn?"],
    \["fnext", "api\\#fnext"],
    \["for", "api\\#for"],
    \["force", "api\\#force"],
    \["format", "api\\#format"],
    \["future", "api\\#future"],
    \["future-call", "api\\#future-call"],
    \["gen-class", "api\\#gen-class"],
    \["gen-interface", "api\\#gen-interface"],
    \["gensym", "api\\#gensym"],
    \["get", "api\\#get"],
    \["get-in", "api\\#get-in"],
    \["get-method", "api\\#get-method"],
    \["get-proxy-class", "api\\#get-proxy-class"],
    \["get-validator", "api\\#get-validator"],
    \["hash", "api\\#hash"],
    \["hash-map", "api\\#hash-map"],
    \["hash-set", "api\\#hash-set"],
    \["identical?", "api\\#identical?"],
    \["identity", "api\\#identity"],
    \["if-let", "api\\#if-let"],
    \["if-not", "api\\#if-not"],
    \["ifn?", "api\\#ifn?"],
    \["import", "api\\#import"],
    \["in-ns", "api\\#in-ns"],
    \["inc", "api\\#inc"],
    \["init-proxy", "api\\#init-proxy"],
    \["instance?", "api\\#instance?"],
    \["int", "api\\#int"],
    \["int-array", "api\\#int-array"],
    \["integer?", "api\\#integer?"],
    \["interleave", "api\\#interleave"],
    \["intern", "api\\#intern"],
    \["interpose", "api\\#interpose"],
    \["into", "api\\#into"],
    \["into-array", "api\\#into-array"],
    \["ints", "api\\#ints"],
    \["io!", "api\\#io"],
    \["isa?", "api\\#isa?"],
    \["iterate", "api\\#iterate"],
    \["iterator-seq", "api\\#iterator-seq"],
    \["key", "api\\#key"],
    \["keys", "api\\#keys"],
    \["keyword", "api\\#keyword"],
    \["keyword?", "api\\#keyword?"],
    \["last", "api\\#last"],
    \["lazy-cat", "api\\#lazy-cat"],
    \["lazy-seq", "api\\#lazy-seq"],
    \["let", "api\\#let"],
    \["letfn", "api\\#letfn"],
    \["line-seq", "api\\#line-seq"],
    \["list", "api\\#list"],
    \["list*", "api\\#list*"],
    \["list?", "api\\#list?"],
    \["load", "api\\#load"],
    \["load-file", "api\\#load-file"],
    \["load-reader", "api\\#load-reader"],
    \["load-string", "api\\#load-string"],
    \["loaded-libs", "api\\#loaded-libs"],
    \["locking", "api\\#locking"],
    \["long", "api\\#long"],
    \["long-array", "api\\#long-array"],
    \["longs", "api\\#longs"],
    \["loop", "api\\#loop"],
    \["macroexpand", "api\\#macroexpand"],
    \["macroexpand-1", "api\\#macroexpand-1"],
    \["make-array", "api\\#make-array"],
    \["make-hierarchy", "api\\#make-hierarchy"],
    \["map", "api\\#map"],
    \["map?", "api\\#map?"],
    \["mapcat", "api\\#mapcat"],
    \["max", "api\\#max"],
    \["max-key", "api\\#max-key"],
    \["memfn", "api\\#memfn"],
    \["memoize", "api\\#memoize"],
    \["merge", "api\\#merge"],
    \["merge-with", "api\\#merge-with"],
    \["meta", "api\\#meta"],
    \["methods", "api\\#methods"],
    \["min", "api\\#min"],
    \["min-key", "api\\#min-key"],
    \["mod", "api\\#mod"],
    \["name", "api\\#name"],
    \["namespace", "api\\#namespace"],
    \["neg?", "api\\#neg?"],
    \["newline", "api\\#newline"],
    \["next", "api\\#next"],
    \["nfirst", "api\\#nfirst"],
    \["nil?", "api\\#nil?"],
    \["nnext", "api\\#nnext"],
    \["not", "api\\#not"],
    \["not-any?", "api\\#not-any?"],
    \["not-empty", "api\\#not-empty"],
    \["not-every?", "api\\#not-every?"],
    \["not=", "api\\#not="],
    \["ns", "api\\#ns"],
    \["ns-aliases", "api\\#ns-aliases"],
    \["ns-imports", "api\\#ns-imports"],
    \["ns-interns", "api\\#ns-interns"],
    \["ns-map", "api\\#ns-map"],
    \["ns-name", "api\\#ns-name"],
    \["ns-publics", "api\\#ns-publics"],
    \["ns-refers", "api\\#ns-refers"],
    \["ns-resolve", "api\\#ns-resolve"],
    \["ns-unalias", "api\\#ns-unalias"],
    \["ns-unmap", "api\\#ns-unmap"],
    \["nth", "api\\#nth"],
    \["nthnext", "api\\#nthnext"],
    \["num", "api\\#num"],
    \["number?", "api\\#number?"],
    \["odd?", "api\\#odd?"],
    \["or", "api\\#or"],
    \["parents", "api\\#parents"],
    \["partial", "api\\#partial"],
    \["partition", "api\\#partition"],
    \["pcalls", "api\\#pcalls"],
    \["peek", "api\\#peek"],
    \["pmap", "api\\#pmap"],
    \["pop", "api\\#pop"],
    \["pos?", "api\\#pos?"],
    \["pr", "api\\#pr"],
    \["pr-str", "api\\#pr-str"],
    \["prefer-method", "api\\#prefer-method"],
    \["prefers", "api\\#prefers"],
    \["print", "api\\#print"],
    \["print-namespace-doc", "api\\#print-namespace-doc"],
    \["print-str", "api\\#print-str"],
    \["printf", "api\\#printf"],
    \["println", "api\\#println"],
    \["println-str", "api\\#println-str"],
    \["prn", "api\\#prn"],
    \["prn-str", "api\\#prn-str"],
    \["proxy", "api\\#proxy"],
    \["proxy-mappings", "api\\#proxy-mappings"],
    \["proxy-super", "api\\#proxy-super"],
    \["pvalues", "api\\#pvalues"],
    \["quot", "api\\#quot"],
    \["rand", "api\\#rand"],
    \["rand-int", "api\\#rand-int"],
    \["range", "api\\#range"],
    \["ratio?", "api\\#ratio?"],
    \["rationalize", "api\\#rationalize"],
    \["re-find", "api\\#re-find"],
    \["re-groups", "api\\#re-groups"],
    \["re-matcher", "api\\#re-matcher"],
    \["re-matches", "api\\#re-matches"],
    \["re-pattern", "api\\#re-pattern"],
    \["re-seq", "api\\#re-seq"],
    \["read", "api\\#read"],
    \["read-line", "api\\#read-line"],
    \["read-string", "api\\#read-string"],
    \["reduce", "api\\#reduce"],
    \["ref", "api\\#ref"],
    \["ref-set", "api\\#ref-set"],
    \["refer", "api\\#refer"],
    \["refer-clojure", "api\\#refer-clojure"],
    \["release-pending-sends", "api\\#release-pending-sends"],
    \["rem", "api\\#rem"],
    \["remove", "api\\#remove"],
    \["remove-method", "api\\#remove-method"],
    \["remove-ns", "api\\#remove-ns"],
    \["remove-watch", "api\\#remove-watch"],
    \["remove-watcher", "api\\#remove-watcher"],
    \["repeat", "api\\#repeat"],
    \["repeatedly", "api\\#repeatedly"],
    \["replace", "api\\#replace"],
    \["replicate", "api\\#replicate"],
    \["require", "api\\#require"],
    \["reset!", "api\\#reset"],
    \["reset-meta!", "api\\#reset-meta"],
    \["resolve", "api\\#resolve"],
    \["rest", "api\\#rest"],
    \["resultset-seq", "api\\#resultset-seq"],
    \["reverse", "api\\#reverse"],
    \["reversible?", "api\\#reversible?"],
    \["rseq", "api\\#rseq"],
    \["rsubseq", "api\\#rsubseq"],
    \["second", "api\\#second"],
    \["select-keys", "api\\#select-keys"],
    \["send", "api\\#send"],
    \["send-off", "api\\#send-off"],
    \["seq", "api\\#seq"],
    \["seq?", "api\\#seq?"],
    \["seque", "api\\#seque"],
    \["sequence", "api\\#sequence"],
    \["sequential?", "api\\#sequential?"],
    \["set", "api\\#set"],
    \["set-validator!", "api\\#set-validator"],
    \["set?", "api\\#set?"],
    \["short", "api\\#short"],
    \["shutdown-agents", "api\\#shutdown-agents"],
    \["slurp", "api\\#slurp"],
    \["some", "api\\#some"],
    \["sort", "api\\#sort"],
    \["sort-by", "api\\#sort-by"],
    \["sorted-map", "api\\#sorted-map"],
    \["sorted-map-by", "api\\#sorted-map-by"],
    \["sorted-set", "api\\#sorted-set"],
    \["sorted?", "api\\#sorted?"],
    \["special-form-anchor", "api\\#special-form-anchor"],
    \["special-symbol?", "api\\#special-symbol?"],
    \["split-at", "api\\#split-at"],
    \["split-with", "api\\#split-with"],
    \["str", "api\\#str"],
    \["stream?", "api\\#stream?"],
    \["string?", "api\\#string?"],
    \["struct", "api\\#struct"],
    \["struct-map", "api\\#struct-map"],
    \["subs", "api\\#subs"],
    \["subseq", "api\\#subseq"],
    \["subvec", "api\\#subvec"],
    \["supers", "api\\#supers"],
    \["swap!", "api\\#swap"],
    \["symbol", "api\\#symbol"],
    \["symbol?", "api\\#symbol?"],
    \["sync", "api\\#sync"],
    \["syntax-symbol-anchor", "api\\#syntax-symbol-anchor"],
    \["take", "api\\#take"],
    \["take-nth", "api\\#take-nth"],
    \["take-while", "api\\#take-while"],
    \["test", "api\\#test"],
    \["the-ns", "api\\#the-ns"],
    \["time", "api\\#time"],
    \["to-array", "api\\#to-array"],
    \["to-array-2d", "api\\#to-array-2d"],
    \["trampoline", "api\\#trampoline"],
    \["tree-seq", "api\\#tree-seq"],
    \["true?", "api\\#true?"],
    \["type", "api\\#type"],
    \["unchecked-add", "api\\#unchecked-add"],
    \["unchecked-dec", "api\\#unchecked-dec"],
    \["unchecked-divide", "api\\#unchecked-divide"],
    \["unchecked-inc", "api\\#unchecked-inc"],
    \["unchecked-multiply", "api\\#unchecked-multiply"],
    \["unchecked-negate", "api\\#unchecked-negate"],
    \["unchecked-remainder", "api\\#unchecked-remainder"],
    \["unchecked-subtract", "api\\#unchecked-subtract"],
    \["underive", "api\\#underive"],
    \["update-in", "api\\#update-in"],
    \["update-proxy", "api\\#update-proxy"],
    \["use", "api\\#use"],
    \["val", "api\\#val"],
    \["vals", "api\\#vals"],
    \["var-get", "api\\#var-get"],
    \["var-set", "api\\#var-set"],
    \["var?", "api\\#var?"],
    \["vary-meta", "api\\#vary-meta"],
    \["vec", "api\\#vec"],
    \["vector", "api\\#vector"],
    \["vector?", "api\\#vector?"],
    \["when", "api\\#when"],
    \["when-first", "api\\#when-first"],
    \["when-let", "api\\#when-let"],
    \["when-not", "api\\#when-not"],
    \["while", "api\\#while"],
    \["with-in-str", "api\\#with-in-str"],
    \["with-local-vars", "api\\#with-local-vars"],
    \["with-meta", "api\\#with-meta"],
    \["with-open", "api\\#with-open"],
    \["with-out-str", "api\\#with-out-str"],
    \["with-precision", "api\\#with-precision"],
    \["xml-seq", "api\\#xml-seq"],
    \["zero?", "api\\#zero?"],
    \["zipmap", "api\\#zipmap"],
    \["clojure.inspector", "api\\#toc621"],
    \["inspect", "api\\#inspect"],
    \["inspect-table", "api\\#inspect-table"],
    \["inspect-tree", "api\\#inspect-tree"],
    \["clojure.main", "api\\#toc625"],
    \["load-script", "api\\#load-script"],
    \["main", "api\\#main"],
    \["repl", "api\\#repl"],
    \["repl-caught", "api\\#repl-caught"],
    \["repl-exception", "api\\#repl-exception"],
    \["repl-prompt", "api\\#repl-prompt"],
    \["repl-read", "api\\#repl-read"],
    \["skip-if-eol", "api\\#skip-if-eol"],
    \["skip-whitespace", "api\\#skip-whitespace"],
    \["with-bindings", "api\\#with-bindings"],
    \["clojure.parallel", "api\\#toc637"],
    \["pany", "api\\#pany"],
    \["par", "api\\#par"],
    \["pdistinct", "api\\#pdistinct"],
    \["pfilter-dupes", "api\\#pfilter-dupes"],
    \["pfilter-nils", "api\\#pfilter-nils"],
    \["pmax", "api\\#pmax"],
    \["pmin", "api\\#pmin"],
    \["preduce", "api\\#preduce"],
    \["psort", "api\\#psort"],
    \["psummary", "api\\#psummary"],
    \["pvec", "api\\#pvec"],
    \["clojure.set", "api\\#toc654"],
    \["difference", "api\\#difference"],
    \["index", "api\\#index"],
    \["intersection", "api\\#intersection"],
    \["join", "api\\#join"],
    \["map-invert", "api\\#map-invert"],
    \["project", "api\\#project"],
    \["rename", "api\\#rename"],
    \["rename-keys", "api\\#rename-keys"],
    \["select", "api\\#select"],
    \["union", "api\\#union"],
    \["clojure.xml", "api\\#toc673"],
    \["parse", "api\\#parse"],
    \["clojure.zip", "api\\#toc676"],
    \["append-child", "api\\#append-child"],
    \["branch?", "api\\#branch?"],
    \["children", "api\\#children"],
    \["down", "api\\#down"],
    \["edit", "api\\#edit"],
    \["end?", "api\\#end?"],
    \["insert-child", "api\\#insert-child"],
    \["insert-left", "api\\#insert-left"],
    \["insert-right", "api\\#insert-right"],
    \["left", "api\\#left"],
    \["leftmost", "api\\#leftmost"],
    \["lefts", "api\\#lefts"],
    \["make-node", "api\\#make-node"],
    \["next", "api\\#next"],
    \["node", "api\\#node"],
    \["path", "api\\#path"],
    \["prev", "api\\#prev"],
    \["remove", "api\\#remove"],
    \["replace", "api\\#replace"],
    \["right", "api\\#right"],
    \["rightmost", "api\\#rightmost"],
    \["rights", "api\\#rights"],
    \["root", "api\\#root"],
    \["seq-zip", "api\\#seq-zip"],
    \["up", "api\\#up"],
    \["vector-zip", "api\\#vector-zip"],
    \["xml-zip", "api\\#xml-zip"],
    \["zipper", "api\\#zipper"]]
endif
