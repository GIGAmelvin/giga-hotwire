Config = {
  Item = 'lockpick', -- Which useable item is required to hotwire?
  Consume = {
    Enabled = true,  -- Should the item be consumed when you use it?
  },
  Duration = {
    Minimum = 20000, -- Minimum time hotwiring can take
    Maximum = 60000, -- Max time hotwiring can take
  },
  Alert = {
    Enabled = 'bike', -- Are automatic police alerts enabled?
  },
  Probability = {
    Success = 0.75, -- How likely it is (0.0 - 1.0) that we succeed.
    Alert = 0.6,    -- If alerts are enabled, how likely is this to be automatically alerted?
  },
  Exempt = {
    Classes = { -- All vehicle classes that cannot be hotwired.
      15,
      16,
      17,
      18,
      19,
      21,
    },
  },
}
