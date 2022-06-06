require "httparty"

class SolrClient
  include HTTParty
  base_uri ENV.fetch("CATALOG_SOLR").to_s

  # So arrayed filter queries are sent the way Solr wants them
  query_string_normalizer proc { |query|
    query.map do |key, value|
      if value.class.to_s == "Array"
        value.map { |v| "#{key}=#{v}" }
      else
        "#{key}=#{value}"
      end
    end.join("&")
  }

  def browse_reference_on_top(reference_id:, rows: 20, core: ENV.fetch("CALLNUMBERS_CORE"))
    # square brackets includes reference in return
    range = "id:[\"#{reference_id}\" TO *]"
    sort = "id asc"
    browse(core: core, rows: rows, sort: sort, range: range)
  end

  def browse_reference_on_bottom(reference_id:, rows: 20, core: ENV.fetch("CALLNUMBERS_CORE"))
    # curly brackets exclues reference in return
    range = "id:{* TO \"#{reference_id}\"}"
    sort = "id desc"
    browse(core: core, rows: rows, sort: sort, range: range)
  end

  def browse(rows:, sort:, range:, core: ENV.fetch("CALLNUMBERS_CORE"))
    query = {
      rows: rows,
      q: "*:*",
      fq: [range],
      sort: sort
    }
    self.class.get("/#{core}/select", query: query)
  end

  def exact_matches(callnumber:, core: ENV.fetch("CALLNUMBERS_CORE"))
    query = {
      q: "*:*",
      fq: %(callnumber:"#{callnumber}"),
      sort: "id asc",
      rows: 5000
    }
    result = self.class.get("/#{core}/select", query: query)
    if result.code != 200
      []
    else
      result.parsed_response["response"]["docs"]&.map { |x| x["id"] }
    end
  end
end
