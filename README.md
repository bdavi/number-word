# number-word

## Summary
NumberWord is a command line application which accepts a Ruby integer literal and prints the extended english spelling of that number.

## Example usage

```bash
~$ ruby number_to_word.rb 134
one hundred thirty four
```

It handles negative numbers and hexadecimal as well:
```bash
~$ ruby number_to_word.rb -0xaabb
negative fourty three thousand, seven hundred  and seven
```

No trouble with binary or underscores: 
```bash
~$ ruby number_to_word.rb 0b001_001
nine
```


