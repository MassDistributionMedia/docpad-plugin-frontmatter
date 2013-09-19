# Frontmatter
### A Table of Contents plugin for DocPad

Simply define your Table of Contents in the plugins section of your project's `docpad.coffee` file:

```coffeescript
 plugins:
	frontmatter:
	      chapters: [
	        title: "Using Stardog"
	        subtitle: "Covers basic installation and starting a Stardog Server in <em>five easy steps</em>."
	        sections: ["using", "console"]
	      ,
	        title: "Administering Stardog"
	        subtitle: "Administering Stardog Server, databases, including configuration and deployment information."
	        sections: ["admin", "security"]
	      ,
	        title: "Programming Stardog"
	        subtitle: "Everything from reasoning, data validation, and SPARQL to programming Stardog with Java, JavaScript, and many other languages. Includes the documentation for Stardog Web."
	        sections: [
	          'java', 'web', 'icv', 'owl2', 'http', 'spring', 'groovy'
	          ,
	            title: 'Programming with Javascript'
	            text:"The documentation for <a href=\"http://clarkparsia.github.io/stardog.js\">stardog.js</a>, which is available on <a href=\"https://github.com/clarkparsia/stardog.js\">Github</a> and <a href=\"http://docs.stardog.com/\">npm</a>."
	        ]
	      ,
	        title: "Understanding Stardog"
	        subtitle: "Background information on tuning, terminology, known issues, compatibility policies, etc."
	        sections: [
	          'manpages', 'performance', 'faq'
	          ,
	            title: "Stardog Compatibility Policies"
	            text: "A statement of the policies we will pursue in evolving Stardog beyond the 1.0 release."
	          ,
	            title: "Known Issues"
	            text: "Click here first before reporting an issue or bug."
	          ,
	            title: "Terminology"
	            text: "A glossary of technical terms used in these docs."
	        ]
	      ]
```

Once your Table of Contents is defined, then insert the html tag &lt;toc:stardog&gt; where you want the table of contents to appear. The tag will be replaced with fully rendered html.

Plugin commissioned by [Clark & Parsia](http://clarkparsia.com/) and developed by [MDM](http://massdistributionmedia.com/). 
