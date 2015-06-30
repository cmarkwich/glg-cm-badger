# Overview

Get the massive list of flags for a CM. Clean up the flags once we have them.
Stick the flags on the element instance so the tempalte for each flag can
be rendered.

# Libraries

We're gonna need some help parsing dates and getting data and stuff:

    moment = require('moment')
    reduce = require('lodash.reduce')

# Utility

## `reduceEpistreamResponse`

The response object from epistream is a flattened series of events. We mostly care about
the row events, but we're on the lookout for error events as well.

    reduceEpistreamResponse = (response) ->
      events = response?.response?.events
      accumulateRows = (list, e) ->
        throw new Error(e) if e.message is 'error'
        return if e.message is not 'row'
        list.push e.columns if e.columns
        list
      reduce events, accumulateRows, []

## `dates`

We get our flags from `councilMember/profile/getFlagsActive.mustache` on epiquery.
The flags come with a bunch of date columns that we enumerate here so that we can
wrap them in a more useful `moment` object:

    dates = [
      'ACTION_DATE'
      'CREATE_DATE'
      'DURATION'
      'HISTORY_CREATE_DATE'
      'LAST_UPDATE_DATE'
    ]

## `filterInactive`

Removes flags where `ACTIVE_IND` is 0.

    filterInactive = (flags) ->
      return if not flags
      flags.filter (flag) -> flag.ACTIVE_IND != 0

## `addExclusive`

If the CM has any exclusive flags, tack on a special flag highlighting that.

    anyExclusive = (flags) ->
      # Right now, only "GLG Leader - Top 5% - Councils Exclusive", type 19.
      exclusive = flags.some (flag) -> flag.COUNCIL_MEMBER_FLAG_ID == 19
      if exclusive
        flags.push flag =
          tooltip: 'Exclusivity Through Leadership Agreement'
          templateName: 'exclusive-flag'
      flags

## `processFlag`

Those flags need more useful information on them for our purposes. That's
what this function does.

It sets a property named `templateName` on each flag. It's the name of the
flag with all the non-alphanumeric characters converted to hyphens. It also
changes each date field from above to a more useful `moment` object.

It also sets the `tooltip` field to a sensible combination of other
fields' info.

    processFlag = (flag) ->
      templateName = flag.FLAG_NAME?.toLowerCase()
        .replace(/%?( ?- ?)|%| |\//gi, '-')
        .replace(/-$/gi, '')
      flag.templateName = "#{templateName}-flag"
      dates.forEach (field) ->
        flag["#{field}_RAW"] = flag[field]
        flag[field] = moment(flag[field])
        flag["#{field}_CALENDAR"] = flag[field].calendar()
      flag.tooltip = "#{flag.FLAG_NAME}"
      flag.tooltip += " - #{flag.COMMENTS}" if flag.COMMENTS
      flag.tooltip += " - #{flag.LAST_UPDATED_BY}" if flag.LAST_UPDATED_BY
      flag.tooltip += " - #{flag.LAST_UPDATE_DATE_CALENDAR}" if flag.LAST_UPDATE_DATE_RAW

      # Uncomment the following to enumerate current flags and template names.
      # console.log templateName, flag.ACTION, flag
      flag

# The `glg-cm-badger` Element

Doesn't do much besides respond to the `core-ajax` call and process the flags.

    Polymer 'glg-cm-badger',
      created: ->

      ready: ->

      attached: ->

      domReady: ->

      detached: ->

      handleBadgeResponse: (e, response) ->
        flags = reduceEpistreamResponse response
        # TODO: Handle errors.
        # TODO: Sort by priority.
        @flags = filterInactive(flags)
          .map(processFlag)
        anyExclusive(@flags)

      handleFeedbackResponse: (e, response) ->
        list = reduceEpistreamResponse response
        @feedback = list[0]

      handleLobbyistResponse: (e, response) ->
        list = reduceEpistreamResponse response
        @lobbyist = list[0]?.lobbyistInd

      percentage: (value) ->
        "#{Math.floor(value * 100)}%"
