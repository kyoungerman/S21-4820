In the expression:

```
round(avg(gdp_growth)::numeric,2)::text||'%' as avg_growth, 
```

| Item            | Description                                                        |
|:----------------|:-------------------------------------------------------------------|
| `avg()`         | take the grouped average of a numeric value - it returns a float   |
| `::numeric`     | convert float to numeric, the input type for round                 |
| `round()`       | round to 2 decimal places                                          |
| `::text`        | convert rounded value to a string so we can add a `%`              |
| `||`            | Concatenate a string                                               |
| `as avg_growth` | name this expression `avg_growth` in the projected columns         |

