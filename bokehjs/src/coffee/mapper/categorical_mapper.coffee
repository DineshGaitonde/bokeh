
define [
  "common/collection",
  "./linear_mapper",
], (Collection, LinearMapper) ->

  class CategoricalMapper extends LinearMapper.Model

    map_to_target: (x) ->
      if typeof(x) == 'number'
        return super(x)
      factors = @get('source_range').get('factors')
      if x.indexOf(':') >= 0
        [factor, percent] = x.split(':')
        percent = parseFloat(percent)
        return super(factors.indexOf(factor) + 0.5 + percent)
      return super(factors.indexOf(x) + 1)

    v_map_to_target: (xs) ->
      if typeof(xs[0]) == 'number'
        return super(xs)
      factors = @get('source_range').get('factors')
      results = Array(xs.length)
      for i in [0...xs.length]
        x = xs[i]
        if x.indexOf(':') >= 0
          [factor, percent] = x.split(':')
          percent = parseFloat(percent)
          results[i] = factors.indexOf(factor) + 0.5 + percent
        else
          results[i] = factors.indexOf(x) + 1
      return super(results)

    map_from_target: (xprime, skip_cat=false) ->
      xprime = super(xprime) - 0.5
      if skip_cat
        return xprime
      factors = @get('source_range').get('factors')
      start = @get('source_range').get('start')
      end = @get('source_range').get('end')
      return factors[Math.floor(xprime-0.5-start)]

    v_map_from_target: (xprimes, skip_cat=false) ->
      result = super(xprimes)
      if skip_cat
        return result
      factors = @get('source_range').get('factors')
      start = @get('source_range').get('start')
      end = @get('source_range').get('end')
      for i in [0...result.length]
        result[i] = factors[Math.floor(result[i]-0.5-start)]
      return result

  class CategoricalMappers extends Collection
    model: CategoricalMapper

  return {
    "Model": CategoricalMapper,
    "Collection": new CategoricalMappers()
  }
