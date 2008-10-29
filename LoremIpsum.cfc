<!--- -->
<fusedoc fuse="LoremIpsum.cfc" language="ColdFusion" specification="2.0">
	<responsibilities>
		I use the XML feed from lipsum.com to generate random placeholder text for testing and wireframing
	</responsibilities>
	<properties>
		<history author="Tim Blair" date="{d '2008-09-29'}" email="tim@bla.ir" type="create" />
		<history author="Tim Blair" date="{d '2008-09-30'}" email="tim@bla.ir" type="modify">
			Added local cache option
		</history> 
		<history author="Tim Blair" date="{d '2008-10-29'}" email="tim@bla.ir" type="modify">
			Retro-fitted for pre-CF8 compatibility
		</history>
	</properties>
</fusedoc>
--->

<cfcomponent output="no" hint="I use the XML feed from lipsum.com to generate random placeholder text for testing and wireframing">

	<cfscript>
		// basic settings
		this.version  = "0.3";
		this.feed_url = "http://www.lipsum.com/feed/xml";
		// defaults for instance variables
		variables.instance = structnew();
		variables.instance.start_with_lorem_ipsum = TRUE;
		variables.instance.use_local_cache        = FALSE;
		variables.instance.cache                  = structnew();
	</cfscript>

	<cffunction name="init" access="public" returntype="LoremIpsum" output="no" hint="Component initialisation">
		<cfargument name="start_with_lorem_ipsum" type="boolean" required="no" default="TRUE" hint="Should the text start with 'Lorem Ipsum'?">
		<cfargument name="use_local_cache" type="boolean" required="no" default="FALSE" hint="Cache same-type requests?">
		<cfset variables.instance.start_with_lorem_ipsum = arguments.start_with_lorem_ipsum>
		<cfset variables.instance.use_local_cache = arguments.use_local_cache>
		<cfreturn this>
	</cffunction>

	<cffunction name="get_paragraphs" access="public" returntype="array" output="no" hint="Returns an array of paragraphs of Lorem Ipsum text">
		<cfargument name="number_of" type="numeric" required="yes" hint="The number of paragraphs to return">
		<cfreturn get_from_cache_or_remote('paras', arguments.number_of)>
	</cffunction>

	<cffunction name="get_words" access="public" returntype="array" output="no" hint="Returns an array of paragraphs of Lorem Ipsum text, capped at a given number of words">
		<cfargument name="number_of" type="numeric" required="yes" hint="The word limit">
		<cfreturn get_from_cache_or_remote('words', arguments.number_of)>
	</cffunction>

	<cffunction name="get_bytes" access="public" returntype="array" output="no" hint="Returns an array of paragraphs of Lorem Ipsum text, capped at a given number of bytes">
		<cfargument name="number_of" type="numeric" required="yes" hint="The byte limit">
		<cfreturn get_from_cache_or_remote('bytes', arguments.number_of)>
	</cffunction>

	<cffunction name="get_from_cache_or_remote" access="private" returntype="array" output="no" hint="">
		<cfargument name="type" type="string" required="yes" hint="The request limit type (paras, words, bytes)">
		<cfargument name="number_of" type="numeric" required="yes" hint="The limit of [type] to return">
		<cfset var local = structnew()>
		<cfset local.cache_location = arguments.type & "_" & arguments.number_of>
		<!--- if the request already exists in the cache then use that --->
		<cfif variables.instance.use_local_cache AND structkeyexists(variables.instance.cache, local.cache_location)>
			<cfreturn variables.instance.cache[local.cache_location]>
		</cfif>
		<!--- otherwise grab from remote --->
		<cfset local.paras = get_from_remote(arguments.type, arguments.number_of)>
		<!--- cache if required --->
		<cfif variables.instance.use_local_cache>
			<cfset variables.instance.cache[local.cache_location] = local.paras>
		</cfif>
		<!--- return the paragraphs --->
		<cfreturn local.paras>
	</cffunction>

	<cffunction name="get_from_remote" access="private" returntype="array" output="no" hint="Actually performs the request to grab the Lorem Ipsum text from the remote server">
		<cfargument name="type" type="string" required="yes" hint="The request limit type (paras, words, bytes)">
		<cfargument name="number_of" type="numeric" required="yes" hint="The limit of [type] to return">
		<cfset var local = structnew()>
		<cfset local.request_uri = get_url(arguments.type, arguments.number_of)>
		<!--- grab the lipsum block --->
		<cfhttp url="#local.request_uri#" method="get" result="local.request"></cfhttp>
		<cfset local.lipsum = xmlparse(local.request.filecontent).feed.lipsum.xmltext>
		<!--- split into paragraphs and return --->
		<cfreturn local.lipsum.split('\n+')>
	</cffunction>

	<cffunction name="get_url" access="private" returntype="string" output="no" hint="Builds the URL for the remote request">
		<cfargument name="type" type="string" required="yes" hint="The request limit type (paras, words, bytes)">
		<cfargument name="number_of" type="numeric" required="yes" hint="The limit of [type] to return">
		<!--- default to paragraphs if we don't have a valid type --->
		<cfif NOT listfind("paras,words,bytes", arguments.type)>
			<cfset arguments.type = "paras">
		</cfif>
		<cfreturn this.feed_url
			    & "?amount=" & arguments.number_of
			    & "&what=" & arguments.type
			    & "&start=" & lcase(yesnoformat(variables.instance.start_with_lorem_ipsum))>
	</cffunction>

	<cffunction name="flush_cache" access="public" returntype="void" output="no" hint="Clears the local cache">
		<cfset variables.instance.cache = {}>
	</cffunction>

</cfcomponent>
