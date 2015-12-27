""  Bugfix, 'swiftKeywords' was missed
syntax region swiftTypeWrapper start="\v:\s*" skip="\s*,\s*$*\s*" end="$" contains=swiftString,swiftBoolean,swiftNumber,swiftType,swiftGenericsWrapper,swiftKeywords transparent

