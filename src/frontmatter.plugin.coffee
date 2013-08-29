# Export Plugin
module.exports = (BasePlugin) ->

  # Define Plugin
  class frontmatterPlugin extends BasePlugin
    # Plugin name
    name: 'frontmatter'

    tocHtml: ''

    config:
      regex: /<toc:frontmatter\/?>/g
      subsectionSelector: '#mdblock h2'
      addHeaderIds: true
      headerIdPrefix: 'sd-'
      chapters: null
    buildPages: () ->
      if @built then return

      @pages = {}

      for chapter in @config.chapters
        for section in chapter.sections
          if @pages[section.page]? || (typeof section isnt 'string' && !section.page) then continue

          if typeof section is 'string'
            @pages[section] = chapter.sections[chapter.sections.indexOf(section)] = {page:section}
          else @pages[section.page] = section

          section.built = false

    buildPage: (file) ->
      name = file.attributes.basename

      page = @pages[name]

      if !page || page.built || file.attributes.outExtension isnt 'html' then return

      #console.log 'buildPage', name

      page.built = true

      #console.log 'build', file.attributes

      page.title = file.attributes.title
      page.url = file.attributes.url
      page.subsections = []

      cheerio = require 'cheerio'
      $ = cheerio.load(file.attributes.contentRendered)

      #console.log('sub', @config.subsectionTag, $(@config.subsectionTag), file.attributes)

      tag = @config.subsectionSelector
      config = @config
      changed = false

      $(tag).each (index, elem) ->
        $th = $(this)
        title = $th.text()
        id = $th.attr('id')

        if !id and config.addHeaderIds
          $th.attr('id', config.headerIdPrefix + title.replace(/[^a-zA-Z0-9]/g, '-').replace(/^-/, '').replace(/-+/, '-'))
          changed = true

        id = $th.attr('id')

        #console.log 'sub', title, id

        obj = {title:title, id:id, url:page.url}
        if id then obj.url += '#' + id
        page.subsections.push(obj)

      if changed then file.attributes.contentRendered = $.html()

    buildTocHtml: () ->
      @built = true
      @tocHtml = ''

      html = ''

      for chapter in @config.chapters
        ch = ''
        ch += "<h2>#{chapter.title}</h2>"
        ch += "<p>#{chapter.subtitle}</p>"

        for section in chapter.sections
          ch += "<h3><a href=\"#{section.url}\">#{section.title}</a></h3>"

          text = if section.text then section.text else ''

          ch += "<p>#{text}</p>"

          console.log 'sec', section

          if section.subsections && section.subsections.length
            ch += "<ol class=\"chapter-toc\">"

            for subsection in section.subsections
              ch += "<li><a href=\"#{subsection.url}\">#{subsection.title}</a></li>"

            ch += "</ol><p></p>"

        html += ch

      @tocHtml = html

    renderBefore: (opts) ->
      # Prepare
      @buildPages()

    render: (opts) ->
      {inExtension, outExtension, templateData, file, content} = opts

      #if file.attributes.filename is 'admin.html.md' then console.log inExtension, outExtension, templateData

    renderDocument: (opts) ->
      file = opts.file

      if file.type isnt 'document' || opts.extension isnt 'html' || file.attributes.sdTocProcessed then return

      file.attributes.sdTocProcessed = true

      name = file.attributes.basename
      if !@pages[name] || !@config.addHeaderIds then return

      #console.log 'render', file.attributes

      # Add Header ids.



    writeBefore: (opts) ->
      documents = @docpad.getCollection 'documents'
      needsToc = []

      for model in documents.models
        @buildPage(model)

        if @config.regex.test(model.attributes.contentRendered) then needsToc.push(model)

      @buildTocHtml()

      for model in needsToc
        model.attributes.contentRendered = model.attributes.contentRendered.replace(@config.regex, @tocHtml)