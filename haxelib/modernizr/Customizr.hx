package modernizr;

import haxe.Http;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
import modernizr.Defaultizr;

using Lambda;
using StringTools;
using tink.macro.tools.MacroTools;

typedef MacroType = haxe.macro.Type;

/**
 * ...
 * @author Skial Bainn
 */

class Customizr {
	
	private static var _version:String = '2.6.2';
	
	private static var _base:String = 'http://modernizr.com/';	
	private static var _name:String = 'modernizr-';
	private static var _ext:String = '.js';
	private static var _path:String = Context.resolvePath('modernizr/assets/' + _name + _version + _ext);
	private static var _feature_detects:String = _path.replace(_name + _version + _ext, '') + 'feature-detects/';
	
	/**
	 * Stolen from the modernizr build script modulizr.js 
	 * https://github.com/Modernizr/modernizr.com/blob/gh-pages/i/js/modulizr.js#L15
	 */
	private static var _dependencies:Dynamic<Array<String>> = {
      'canvastext'      : ['canvas'],
      'csstransforms3d' : ['prefixes', 'domprefixes', 'testprop', 'testbundle', 'teststyles', 'testallprops'],
      'flexbox'         : ['domprefixes', 'testprop', 'testallprops'],
      'cssgradients'    : ['prefixes'],
      'opacity'         : ['prefixes'],
      'indexeddb'       : ['domprefixes'],
      'backgroundsize'  : ['domprefixes', 'testprop', 'testallprops'],
      'borderimage'     : ['domprefixes', 'testprop', 'testallprops'],
      'borderradius'    : ['domprefixes', 'testprop', 'testallprops'],
      'boxshadow'       : ['domprefixes', 'testprop', 'testallprops'],
      'cssanimations'   : ['domprefixes', 'testprop', 'testallprops'],
      'csscolumns'      : ['domprefixes', 'testprop', 'testallprops'],
      'cssreflections'  : ['domprefixes', 'testprop', 'testallprops'],
      'csstransitions'  : ['domprefixes', 'testprop', 'testallprops'],
      'testallprops'    : ['domprefixes', 'testprop'],
      'flexbox-legacy'  : ['domprefixes', 'testprop', 'testallprops'],
      'prefixed'        : ['domprefixes', 'testprop', 'testallprops'],
      'csstransforms'   : ['domprefixes', 'testprop', 'testallprops'],
      'mq'              : ['teststyles'],
      'hashchange'      : ['hasevent'],
      'draganddrop'     : ['hasevent'],
      'generatedcontent': ['smile', 'testbundle', 'teststyles'],
      'svg'             : ['ns'],
      'inlinesvg'       : ['ns'],
      'smil'            : ['ns'],
      'svgclippaths'    : ['ns'],
      'input'           : ['webforms', 'inputelem'],
      'inputtypes'      : ['webforms', 'inputelem', 'smile'],
      'touch'           : ['prefixes', 'testbundle', 'teststyles'],
      'fontface'        : ['testbundle', 'teststyles'],
      'testbundle'      : ['teststyles'],
      'respond'         : ['mq', 'teststyles'],
      'websockets'      : ['domprefixes'],

      // community - Feb 6 2012
      'a_download' : [],
      'audio_audiodata_api' : [],
      'audio_webaudio_api' : [],
      'battery_api' : ['domprefixes', 'testprop', 'testallprops', 'prefixed'],
      'battery_level' : ['domprefixes', 'testprop', 'testallprops', 'prefixed'],
      'canvas_todataurl_type' : ['canvas'],
      'contenteditable' : [],
      'contextmenu' : [],
      'cookies' : [],
      'cors' : [],
      'css_backgroundcliptext' : ['prefixes'],
      'css_backgroundrepeat' : ['teststyles'],
      'css_backgroundsizecover' : ['teststyles'],
      'css_boxsizing' : ['testallprops'],
      'css_cubicbezierrange' : ['prefixes'],
      'css_displayrunin' : ['teststyles'],
      'css_displaytable' : [],
      'css_hyphens' : ['prefixes', 'testallprops'],
      'css_mask' : ['testallprops'],
      'css_mediaqueries' : ['teststyles', 'mq'],
      'css_overflow_scrolling' : ['testallprops'],
      'css_pointerevents' : [],
      'css_remunit' : [],
      'css_resize' : ['testallprops'],
      'css_scrollbars' : ['prefixes', 'teststyles'],
      'css_userselect' : ['testallprops'],
      'custom_protocol_handler' : [],
      'dataview_api' : [],
      'dom_classlist' : [],
      'dom_createElement_attrs' : [],
      'dom_dataset' : [],
      'dom_microdata' : [],
      'elem_datalist' : [],
      'elem_details' : [],
      'elem_output' : [],
      'elem_progress_meter' : [],
      'elem_ruby' : [],
      'elem_time' : [],
      'elem_track' : [],
      'emoji' : ['canvas', 'canvastext'],
      'es5_strictmode' : [],
      'event_deviceorientation_motion' : [],
      'file_api' : [],
      'file_filesystem' : ['domprefixes'],
      'forms_placeholder' : ['webforms', 'input', 'inputelem', 'smile', 'inputtypes'],
      'forms_speechinput' : [],
      'forms_validation' : [],
      'fullscreen_api' : ['domprefixes'],
      'gamepad' : [],
      'getusermedia' : [],
      'ie8compat' : [],
      'img_apng' : ['canvas'],
      'img_webp' : [],
      'json' : [],
      'lists_reversed' : [],
      'mathml' : [],
      'network_connection' : [],
      'network_eventsource' : [],
      'notification' : ['domprefixes', 'testprop', 'testallprops', 'prefixed'],
      'performance' : ['domprefixes', 'testprop', 'testallprops', 'prefixed'],
      'quota_management_api' : ['domprefixes', 'testprop', 'testallprops', 'prefixed'],
      'requestanimationframe' : ['domprefixes', 'testprop', 'testallprops', 'prefixed'],
      'script_async' : [],
      'script_defer' : [],
      'unicode' : ['teststyles'],
      'url_data_uri' : [],
      'userdata' : [],
      'web_intents' : [],
      'webgl_extensions' : ['webgl'],
      'websockets_binary' : [],
      'window_framed' : [],
      'workers_blobworkers' : [],
      'workers_dataworkers' : [],
      'workers_sharedworkers' : [],

      /* added  july 16 2012 */
      'blob-constructor' : [],
      'css-backgroundcliptext' : [],
      'css-backgroundposition-fourvalues' : [],
      'css-backgroundposition-xy' : ['teststyles'],
      'css-calc' : ['prefixes'],
      'css-lastchild' : ['teststyles'],
      'css-regions' : ['prefixed'],
      'css-subpixelfont' : ['teststyles'],
      'network-xhr2' : [],
      'style-scoped' : [],
      'svg-filters' : [],
      'forms-fileinput' : [],
      'vibrate' : [],
      'vibration' : [],

      /* added sept 3rd */
      'contentsecuritypolicy' : [],
      'css-objectfit' : ['prefixed'],
      'css-positionsticky' : ['prefixes'],
      'css-supports' : [],
      'css-vhunit' : ['teststyles'],
      'css-vmaxunit' : ['teststyles'],
      'css-vminunit' : ['teststyles'],
      'css-vwunit' : ['teststyles'],
      'forms-formattribute' : [],
      'iframe-sandbox' : [],
      'iframe-seamless' : [],
      'iframe-srcdoc' : [],
      'pointerlock-api' : ['prefixed']
	}
	
	@:macro
	public static function build():Array<Field> {
		if (Context.defined('dce')) {
			var old_fields = Context.getBuildFields();
			var new_fields:Array<Field> = [];
			
			for (f in old_fields) {
				var _name = f.name.toLowerCase();
				var _complex = switch(f.kind) { case FVar(t, _): t; default: };
				var _expr = switch(f.kind) { case FVar(_, e): e; default: };
				var _func = _expr == null ? Context.parse('untyped __js__("Modernizr.' + _name + '")', f.pos) : _expr;
				var _enum = Type.enumConstructor(f.kind);
				
				if (_enum == 'FProp' || _enum == 'FFun') {
					new_fields.push(f);
					continue;
				}
				
				var _field = {
					name:f.name,
					access:[APublic,AStatic],
					kind:FVar(_complex, _func),
					pos:f.pos,
					meta:f.meta,
					doc:f.doc
				}
				
				new_fields.push(_field);
			}
			
			Context.onGenerate(izr_alpha);
			
			return new_fields;
		}
		return Context.getBuildFields();
	}
	
	private static function izr_alpha(types:Array<MacroType>):Void {
		var tests:Hash<Array<String>> = new Hash<Array<String>>();
		var non_core:Hash<Bool> = new Hash<Bool>();
		
		if (Defaultizr.printShiv) Defaultizr.shiv = false;
		if (!Defaultizr.shiv && !Defaultizr.printShiv) Defaultizr.shiv = true;
		
		for (t in types) {
			switch(t) {
				case TInst(type, params):
					
					var cls = type.get();
					
					if (cls.name == 'Modernizr') {
						for (f in cls.statics.get()) {
							
							if (f.meta.has(':feature_detect') && f.meta.has(':?used')) {
								var m = f.meta.get();
								var n = f.name.toLowerCase();
								
								for (meta in m) {
									if (meta.name == ':feature_detect') {
										if (meta.params.length > 0) {
											n = meta.params[0].toString().replace('"', '').toLowerCase();
										}
									}
								}
								
								non_core.set(n, true);
								Compiler.removeField(cls.name, f.name, true);
							}
							if (f.meta.has(':?used')) tests.set(f.name.toLowerCase(), []);
							
						}
					} 
					
					if (cls.name == 'Defaultizr') {
						for (f in cls.statics.get()) {
							
							if (!f.meta.has(':ignore') && Context.getTypedExpr(f.expr()).toString() == 'true') {
								
								tests.set(f.name.toLowerCase(), []);
								
							}
						}
					}
					
				default:
					
			}
		}
		
		izr_omega(File.getContent(_path), tests, non_core);
	}
	
	private static function _check_dependencies(tests:Hash<Array<String>>, features:Hash<Bool>):Hash<Array<String>> {
		var key:String = '';
		
		for (d in Reflect.fields(_dependencies)) {
			key = StringTools.replace(d, '_', '-').toLowerCase();
			
			if (features.exists(key)) {
				
				for (z in cast(Reflect.field(_dependencies, d), Array<Dynamic>)) {
					key = StringTools.replace(z, '_', '-').toLowerCase();
					if (!tests.exists(key)) tests.set(key, []);
				}
				
			}
		}
		
		for (d in Reflect.fields(_dependencies)) {
			key = StringTools.replace(d, '_', '-').toLowerCase();
			
			if (tests.exists(key)) {
				
				for (z in cast(Reflect.field(_dependencies, d), Array<Dynamic>)) {
					key = StringTools.replace(z, '_', '-').toLowerCase();
					if (!tests.exists(key)) tests.set(key, []);
				}
				
			}
		}
		
		return tests;
	}
	
	private static function izr_omega(source:String, tests:Hash<Array<String>>, non_core:Hash<Bool>):Void {
		
		tests = _check_dependencies(tests, non_core);
		
		var new_source:String = source;
		var result:String = '/* Modernizr ' + _version + ' (Haxe Custom Build) http://haxe.org/ | MIT & BSD\n * Build: http://modernizr.com/download/#';
		
		var marker:EReg = ~/^\s*\/\*>>(\w*)\*\/$(?:[\w\W]*?)^\s*\/\*>>(\1)\*\/$/m;
		
		// If short hand ereg ~/.../m, it causes autocompletion issues.
		var test:EReg = new EReg('^\\s*(?:tests\\[\')(\\w*)(?:\']\\s=\\s[\\w\\W]*?};)$', 'm');
		
		new_source = _strip_test(test, new_source, tests);
		new_source = _strip_test(marker, new_source, tests);
		
		new_source = _check_prefix(new_source);
		
		new_source += _last_checks();
		
		for (ncore in non_core.keys()) {
			new_source += _load_feature_detect(ncore);
		}
		
		for (key in tests.keys()) {
			result += '-' + key.replace('-', '_');
		}
		
		for (key in non_core.keys()) {
			result += '-' + key.replace('-', '_');
		}
		
		result += (Defaultizr.prefixed ? '-cssclassprefix:' + Defaultizr.cssPrefix.replace('_', '!') : '');
		result += new_source;
		
		var output:String = Compiler.getOutput();
		output = output.substr(0, output.lastIndexOf('/'));
		
		File.saveContent(output + '/modernizr-' + _version + '.hx' + _ext, result);
	}
	
	private static function _strip_test(ereg:EReg, text:String, tests:Hash<Array<String>>):String {
		var result = '';
		var matched = '';
		
		while (true) {
			if (ereg.match(text) && matched != ereg.matched(0)) {
				matched = ereg.matched(0);
				
				if (tests.exists(ereg.matched(1).trim().toLowerCase())) {
					result += ereg.matchedLeft() + matched;
				} else {
					result += ereg.matchedLeft();
				}
				text = ereg.matchedRight();
			} else {
				break;
			}
		}
		
		result += text;
		
		return result;
	}
	
	private static function _check_prefix(text:String):String {
		var css_prefix:EReg = ~/["']\sjs\s["']\s*\+\s*([\w]+).join\(["'] ["']\)/;
		var css_name:EReg = ~/className\s*\+=\s*["']\s['"]/;
		
		if (Defaultizr.cssClasses && Defaultizr.cssPrefix != '') {
			var new_prefix = Defaultizr.cssPrefix;
			
			if (css_prefix.match(text)) {
				text = css_prefix.replace(text, '" ' + new_prefix + 'js ' + new_prefix + '"+' + css_prefix.matched(1) + '.join(" ' + new_prefix + '")');
			}
			
			if (css_name.match(text)) {
				text = css_name.replace(text, 'className+=" ' + new_prefix + '"');
			}
		}
		
		return text;
	}
	
	private static function _load_feature_detect(name:String):String {
		name = name.replace('_', '-');
		
		var result = '';
		var path = _feature_detects + name + _ext;
		
		if (FileSystem.exists(path)) {
			result = File.getContent(path);
		} else {
			trace(path);
		}
		
		return result;
	}
	
	private static function _last_checks():String {
		var result = '';
		
		if (Defaultizr.printShiv && !Defaultizr.shiv) result += File.getContent(Context.resolvePath('modernizr/assets/html5shiv-printshiv-3.6.js'));
		if (Defaultizr.load) result += File.getContent(Context.resolvePath('modernizr/assets/modernizr.load.1.5.4.js'));
		
		return result;
	}
	
}