// Introduces Event delegation (http://icant.co.uk/sandbox/eventdelegation)
Object.extend(Event, {
  delegate: function(element, eventName, targetSelector, handler) {
    var element = $(element);

    function selectorMatch(element) {
      return element.match(targetSelector);
    }

    function validateTarget(origin) {
      if ( origin.match(targetSelector) ) { return origin; }
      var ancestors = origin.ancestors();
      return ancestors.find(selectorMatch);
    }

    function createDelegation(_delegatedEvent) {
      var rawOrigin = _delegatedEvent.element();
      var origin = validateTarget(rawOrigin);
      if ( origin != null && (typeof handler == 'function') ){
        _delegatedEvent.element = function() { return origin; };
        return handler(_delegatedEvent);
      }
    }

    element.observe(eventName, createDelegation);
    return element;
  },

  delegators: function(element, eventName, rules) {
    var element = $(element);
    function delegateRule(rule) {
      element.delegate(eventName, rule.key, rule.value);
    }
    $H(rules).each(delegateRule);
    return element;
  }
});


Element.addMethods({
  delegate: Event.delegate,
  delegators: Event.delegators
});

Object.extend(document, {
  delegate: Event.delegate,
  delegators: Event.delegators
});
