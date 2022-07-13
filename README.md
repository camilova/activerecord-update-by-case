# Activerecord update_by_case

This gem adds two methods to the `ActiveRecord::Base` class that allow you to update many records on a single database hit, using a `case sql statement` for it.

- `update_by_case!(cases)`
- `update_by_case(cases)`

The only difference between both methods is that `update_by_case!` (with a bang) raises any exception and the other simply returns `true` or `false` depending if the update was successful or not.

By this time, this only works and was tested using `PostgreSQL`. Others `DBMS` should work if they support `CASE` statement on SQL queries.

## Installation

Add to your Gemfile:

    gem 'update_by_case'

Then run `bundler`

## Usage

Pass a `cases` **hash** as the only one argument to `update_by_case(cases)` where `cases` must have the following structure:

- Any key on the first level will be an `attribute` of the `model` to be updated.
- Inside any first level's keys nest a new hash with **one** key that will be the comparison field for the cases.
- Any pair of key|value inside the comparison field hash will be the case and the value to update for each case.

### Example of Cases

Having a model `PatientTemperature` with attributes: 
- `id` 
- `temperature` 
- `passport_number`
- `flight_number`

And data in `patient_temperatures` table:

| id | temperature | passport_number | flight_number |
| :--- | :---: | :---: | :---: |
| 1 | NULL | 111 | 755 |
| 2 | NULL | 222 | 755 |
| 3 | NULL | 333 | 755 |

Then we need to update all Patient's temperatures based on its `passport_number` on a single database hit, we build first the next cases hash:

    cases = {
      temperature: {
        passport_number: {
          111 => 37.5,
          222 => 39.2,
          333 => 36.1,
        }
      }
    }

And then on the model `PatientTemperature` we use `update_by_case(cases)` method as follow:

    PatientTemperature.update_by_case(cases)

This will generate a `SQL UPDATE` like:

    UPDATE patient_temperatures 
    SET temperature = (
      CASE passport_number 
      WHEN 111 then 37.5
      WHEN 222 then 39.2
      WHEN 333 then 36.1
      ELSE temperature
      END
    )::DECIMAL;

The result will be the update of all records on a single SQL query.

### WHERE Clause inside `cases` Hash

You can include a WHERE clause inside your `cases` Hash too, this way you limit the number of records to be processed on large tables:

    cases = {
      temperature: {
        passport_number: {
          111 => 37.5,
          222 => 39.2,
          333 => 36.1,
        }
      },
      where: { flight_number: 755 }
    }

Generating the same SQL but with a WHERE clause like normal ActiveRecord `where` method.

    UPDATE patient_temperatures 
    SET temperature = (
      CASE passport_number 
      WHEN 111 then 37.5
      WHEN 222 then 39.2
      WHEN 333 then 36.1
      ELSE temperature
      END
    )::DECIMAL
    WHERE flight_number = 755;

### Usage Considerations

If you ommit the comparison field, this will be assumed to be the `id` field, for example:

    cases = {
      temperature: {
        1 => 37.5,
        2 => 39.2,
        3 => 36.1,
      }
    }

Will generate SQL as follows:

    UPDATE patient_temperatures 
    SET temperature = (
      CASE id 
      WHEN 1 then 37.5
      WHEN 2 then 39.2
      WHEN 3 then 36.1
      ELSE temperature
      END
    )::DECIMAL;

The resulting SQL statement include a casting of the result of the **CASE**, that allows you to use any type of values for the cases, but all values must be of the same type, because they will be assigned to one field, wich holds one type.

On large tables, you should scope the amount of records to process including a `where` options on cases Hash, that normally will be the same subset that is being updated with the cases.

You can add more than one field to be updated, for example, updating `temperature` and `passport_number` for each instance of `PatientTemperature` based on they `id` should pass a Hash like the following:

    cases = {
      temperature: {
        1 => 37.5,
        2 => 39.2,
        3 => 36.1,
      },
      passport_number: {
        1 => 111,
        2 => 222,
        3 => 333,
      },
      where: { id: [1, 2, 3] }
    }

Will produce the following SQL:

    UPDATE patient_temperatures 
    SET temperature = (
      CASE id 
      WHEN 1 then 37.5
      WHEN 2 then 39.2
      WHEN 3 then 36.1
      ELSE temperature
      END
    )::DECIMAL,
    passport_number = (
      CASE id 
      WHEN 1 then 111
      WHEN 2 then 222
      WHEN 3 then 333
      ELSE passport_number
      END
    )::INTEGER
    WHERE id in (1, 2, 3);

## Contributing

Bug reports and pull requests are welcome!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
