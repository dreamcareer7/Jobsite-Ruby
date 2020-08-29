VERIFICATIONS = [
  { name: "Interviewed by Muqawiloon" },
  { name: "Insurance checked" },
  { name: "ID checked" },
  { name: "References checked" },
  { name: "3 accreditations checked" },
  { name: "Limited Company checked" },
  { name: "Address checked" },
  { name: "Muqawiloon standard checked" }
]

VERIFICATIONS.each do |verification|
  Verification.create( name: verification[:name] )
end

Business.all.each do |business|
	(rand(0..3)..rand(4..7) ).each do |x|
		business.business_verifications.build( {verification_id: Verification.offset(x).first.id } )
	end
	business.save!
end

CERTIFICATIONS = [
  { name: "WHIMIS Certified" },
  { name: "ISO 9001" },
  { name: "Food Safety Certificate" },
  { name: "Member of BBB" },
  { name: "Insurance Certificate" },
  { name: "Muqawiloon Certified" },
  { name: "Master Builder" },
  { name: "Handyman.Com Certification" }
]

CERTIFICATIONS.each do |certification|
  Certification.create( name: certification[:name] )
end

Business.active.each do |business|
	(rand(0..3)..rand(4..7) ).each do |x|
		business.business_certifications.build( {certification_id: Certification.offset(x).first.id } )
	end
	business.save!
end
