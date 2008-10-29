<!--- -->
<fusedoc fuse="lipsum_test.cfm" language="ColdFusion" specification="2.0">
	<responsibilities>
		I test the funky abilities of the Lorem Ipsum generator
	</responsibilities>
	<properties>
		<property name="version" value="">
		<property name="lastcheckin" value="">
		<history author="Tim Blair" date="{d '2008-09-30'}" email="tblair@globalpersonals.co.uk" type="create" />
	</properties>
</fusedoc>
--->

<!--- two copies of the generator, one with caching and one without --->
<cfset variables.generator_without_cache = createobject("component", "LoremIpsum").init(FALSE, FALSE)>
<cfset variables.generator_with_cache    = createobject("component", "LoremIpsum").init(FALSE, TRUE)>

<!--- how many runs, what type, and over what range? --->
<cfset variables.run = {
	loop = 100,
	type = 'paragraphs',
	min  = 1,
	max  = 3
}>

<cfoutput>
	<h1>Lorem Ipsum Testing</h1>
	<p>Using LoremIpsum.cfc version #variables.generator_without_cache.version#</p>
	<h3>Fetching #variables.run.loop# sets of between #variables.run.min# and #variables.run.max# #variables.run.type#
</cfoutput>
<cfflush>

<!--- seed the randomiser --->
<cfset randomize(right(gettickcount(), 8), 'SHA1PRNG')>

<!--- without caching --->
<cfoutput><h4>Running without caching...</cfoutput><cfflush>
<cfset variables.without_tick_start = gettickcount()>
<cfloop from="1" to="#variables.run.loop#" index="i">
	<cfset variables.args = { number_of = randrange(variables.run.min, variables.run.max) }>
	<cfinvoke component="#variables.generator_without_cache#" method="get_#variables.run.type#" argumentcollection="#variables.args#">
</cfloop>
<cfset variables.without_tick_end = gettickcount()>
<cfoutput>done!</h4></cfoutput><cfflush>

<!--- with caching --->
<cfoutput><h4>Running with caching...</cfoutput><cfflush>
<cfset variables.with_tick_start = gettickcount()>
<cfloop from="1" to="#variables.run.loop#" index="i">
	<cfset variables.args = { number_of = randrange(variables.run.min, variables.run.max) }>
	<cfinvoke component="#variables.generator_with_cache#" method="get_#variables.run.type#" argumentcollection="#variables.args#">
</cfloop>
<cfset variables.with_tick_end = gettickcount()>
<cfoutput>done!</h4></cfoutput><cfflush>

<cfoutput>
	<h2>Without caching: #variables.without_tick_end-variables.without_tick_start#ms (#(variables.without_tick_end-variables.without_tick_start)/variables.run.loop#ms/req)</h2>
	<h2>With caching: #variables.with_tick_end-variables.with_tick_start#ms (#(variables.with_tick_end-variables.with_tick_start)/variables.run.loop#ms/req)</h2>
</cfoutput>
