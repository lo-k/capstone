class ApiHelper

  def self.create_emo_percents_hash(emo_results_hash)
    total = calc_emo_total(emo_results_hash)
    emo_percents_hash = calc_emo_percents(emo_results_hash, total)

    sorted_hash = emo_percents_hash.sort_by do |emotion, value|
      value
    end.reverse

    return sorted_hash
  end

  def self.calc_emo_total(emo_results_hash)
    total = 0

    emo_results_hash.each do |emotion, value|
      total += value
    end

    return total
  end

  def self.calc_emo_percents(emo_results_hash, total)
    percents_hash = {}

    emo_results_hash.each do |emotion, value|
      emo_percent = value > 0 ? ((value/total)* 100).round(1) : 0

      percents_hash[emotion.to_sym] = emo_percent
    end

    return percents_hash
  end

end