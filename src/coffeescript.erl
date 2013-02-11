
-module(coffeescript).
-export([init/1, resource_exists/2, content_types_provided/2, to_javascript/2,
	 get_compiler_source/0, get_coffeescript_source/1, compile/1, source_dir/0]).
-include_lib("webmachine/include/webmachine.hrl").

source_dir() ->
    code:priv_dir(coffeescript).


get_compiler_source () ->
    file:read_file(filename:join([source_dir(), "coffee-script.js"])).

get_coffeescript_source(File) ->
    file:read_file(filename:join([source_dir(),"www", File])).
       

compile(File) ->
    {ok, FileData}		= get_coffeescript_source(File),
    {ok, CoffeeScript}		= get_compiler_source(),
    {ok, JS}			= js_driver:new(),
    js:define(JS, CoffeeScript),
    js:call(JS, <<"CoffeeScript.compile">>, [FileData]).
	

init([]) -> {ok, undefined}.


resource_exists(ReqData, Context) ->
    Path			= wrq:disp_path(ReqData), 
    Exists			= filelib:is_regular(filename:join([source_dir(),"www", Path])),
    {Exists, ReqData, Context}.

content_types_provided(ReqData, Context) ->
    {[{"application/javascript", to_javascript}], ReqData, Context}.
    
to_javascript(ReqData, Context) ->
    Path			= wrq:disp_path(ReqData),
    {ok, JavascriptSource}	= compile(Path),
    {JavascriptSource, ReqData, Context}.
