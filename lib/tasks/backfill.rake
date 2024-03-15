namespace :backfill do
  desc 'Generate all disbursements for all merchants'
  task disbursements: [:environment] do
    GenerateMerchantsDisbursementsCron.run
  end

  desc 'Generate all fees charges for all merchants'
  task fees_charges: [:environment] do
    Merchant.find_each { Merchants::CalculateFeesChargesService.call(merchant: _1) }
  end
end

desc 'Generate all fees charges for all merchants'
task year_to_year_report: [:environment] do
  disbursements_volume_by_year =  Disbursement.group("DATE_PART('Year', created_at)").count(:id)
  disbursements_value_by_year =  Disbursement.group("DATE_PART('Year', created_at)").sum(:merchant_paid_amount)
  orders_amount_by_year = Disbursement.group("DATE_PART('Year', created_at)").sum(:orders_amount)
  fees_charges_volume_by_year =  FeesCharge.group("DATE_PART('Year', date)").count(:id)
  fees_charges_value_by_year =  FeesCharge.group("DATE_PART('Year', date)").sum(:outstanding_fees)

  years = (disbursements_volume_by_year.keys + fees_charges_volume_by_year.keys).uniq

  report = years.map do |year|
    {
      "Year" => year.to_i,
      "Number of disbursements" => disbursements_volume_by_year[year].to_i,
      "Amount disbursed to merchants" => "#{disbursements_value_by_year[year].to_f} €",
      "Amount of order fees" => "#{orders_amount_by_year[year].to_f} €",
      "Number of monthly fees charged (From minimum monthly fee)" => fees_charges_volume_by_year[year].to_i,
      "Amount of monthly fee charged (From minimum monthly fee)" => "#{fees_charges_value_by_year[year].to_f} €"
    }
  end

  File.write(Rails.root.join('data/final_report.json'), Oj.dump(report))
end
