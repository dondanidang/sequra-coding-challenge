SeQura Backend Coding Challenge
--
# Context
seQura provides e-commerce shops with a flexible payment method that allows shoppers to split their purchases in three months without any cost. In exchange, seQura earns a fee for each purchase.

When shoppers use this payment method, they pay directly to seQura. Then, seQura disburses the orders to merchants with different frequencies and pricing.

This challenge is about implementing the process of paying merchants.

# Problem statement
We have to implement a system to automate the calculation of merchants’ disbursements payouts and seQura commissions for existing, present in the CSV files, and new orders.

The system must comply with the following requirements:
- All orders must be disbursed precisely once.
- Each disbursement, the group of orders paid on the same date for a merchant, must have a unique alphanumerical reference.
- Orders, amounts, and fees included in disbursements must be easily identifiable for reporting purposes.

The disbursements calculation process must be completed, for all merchants, by 8:00 UTC daily, only including those merchants that fulfill the requirements to be disbursed on that day. Merchants can be disbursed daily or weekly. We will make weekly disbursements on the same weekday as their live_on date (when the merchant started using seQura, present in the CSV files). Disbursements groups all the orders for a merchant in a given day or week.

For each order included in a disbursement, seQura will take a commission, which will be subtracted from the merchant order value gross of the current disbursement, following this pricing:
- 1.00 % fee for orders with an amount strictly smaller than 50 €.
- 0.95 % fee for orders with an amount between 50 € and 300 €.
- 0.85 % fee for orders with an amount of 300 € or more.
Remember that we are dealing with money, so we should be careful with related operations. In this case, we should round up to two decimals following.

Lastly, on the first disbursement of each month, we have to ensure the minimum_monthly_fee for the previous month was reached. The minimum_monthly_fee ensures that seQura earns at least a given amount for each merchant.

When a merchant generates less than the minimum_monthly_fee of orders’ commissions in the previous month, we will charge the amount left, up to the minimum_monthly_fee configured, as “monthly fee”. Nothing will be charged if the merchant generated more fees than the minimum_monthly_fee.

Charging the minimum_monthly_fee is out of the scope of this challenge. It is not subtracted from the disbursement commissions. Just calculate and store it for later usage.

More info about this challenge can be found [here](https://sequra.github.io/backend-challenge/)

# Our solution
Our solution is based on Ruby on Rails, Sidekiq, and Postgres with the following bloc:
1. Using Sidekiq and Sidekiq-cron, we have set up 2 cron jobs:
  - The first cron runs every 1st of the month at midnight and is responsible for computing merchants' fee charges of the previous month
  - The second cron runs every day at 3 am and is responsible for generating merchants' disbursements of previous cycles
2. We have added some rake tasks in case we need to manually trigger the process of generating disbursements or fee charges
3. There is also a rake task that consumes the `disbursements` and `fees_charges` tables to generate the final year-to-year report and save it in `/data` folder

# Setup the environment
Except for rails that need to be installed in the local machine, other dependencies like Redis and Postgres are dockerized. To properly test the solution locally, I recommend previously installing docker and ruby v3.2.2. Next, follow the steps below:
1. Install rails dependencies: `bundle install`
2. Run DB server: `make db-up`
3. Run Redis server: `make redis`
4. Run the background job: make procs
5. Run the app server: rails s
With this, we have everything ready to start including the background job dashboard that is available on htpp:localhost/sidekiq

# Run the solution
We have some rake tasks to prepare the database and generate the final report:
1. Populate the orders and merchants tables with the sample provided in orders CSV and merchants CSV: `rails db:seed`
2. Generate disbursements for all merchants: `rails backfill:disbursements`
3. Compute fees charges for all merchants: `rails backfill:fees_charges`
4. Generate the final report: `rails year_to_year_report`. This will generate and store a json file in `data/final_report.son` 

# Result
After following all the steps above, the result looks like this:
| Year | Number of disbursements | Amount disbursed to merchants | Amount of order fees | Number of monthly fees charged (From minimum monthly fee) | Amount of monthly fee charged (From minimum monthly fee) |
| ---- | ----------------------- | ----------------------------- | -------------------- | --------------------------------------------------------- | -------------------------------------------------------- |
| 2023 | 10391                   | 188564599.51 €                | 1709260.98 €         | 129                                                       | 2171.77 €                                                |
| 2022 | 1509                    | 36929320.27 €                 | 333677.15 €          | 17                                                        | 330.46 €                                                 |

# N.B.
- At the current stage, we have intentionally decided not to test `ImportFromCsvFileService` since we are using only for seed, hence, manually testing it with our the sample provided



