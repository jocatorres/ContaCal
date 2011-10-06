# -*- encoding : utf-8 -*-
class String
  def noaccents
    permalink = self.dup.downcase
    permalink = permalink.strip
    permalink.gsub!(/[àáâãäåāăÀÁÂÃÄÅĀĂ]/, 'a')
    permalink.gsub!(/æÆ/, 'ae')
    permalink.gsub!(/[ďđĎĐ]/, 'd')
    permalink.gsub!(/[çćčĉċÇĆČĈĊ]/, 'c')
    permalink.gsub!(/[èéêëēęěĕėÈÉÊËĒĘĚĔĖ]/, 'e')
    permalink.gsub!(/ƒƑ/, 'f')
    permalink.gsub!(/[ĝğġģĜĞĠĢ]/, 'g')
    permalink.gsub!(/[ĥħĤĦ]/, 'h')
    permalink.gsub!(/[ììíîïīĩĭÌÌÍÎÏĪĨĬ]/, 'i')
    permalink.gsub!(/[įıĳĵĮIĲĴ]/, 'j')
    permalink.gsub!(/[ķĸĶĸ]/, 'k')
    permalink.gsub!(/[łľĺļŀŁĽĹĻĿ]/, 'l')
    permalink.gsub!(/[ñńňņŉŋÑŃŇŅŉŊ]/, 'n')
    permalink.gsub!(/[òóôõöøōőŏŏÒÓÔÕÖØŌŐŎŎ]/, 'o')
    permalink.gsub!(/œŒ/, 'oe')
    permalink.gsub!(/ąĄ/, 'q')
    permalink.gsub!(/[ŕřŗŔŘŖ]/, 'r')
    permalink.gsub!(/[śšşŝșŚŠŞŜȘ]/, 's')
    permalink.gsub!(/[ťţŧțŤŢŦȚ]/, 't')
    permalink.gsub!(/[ùúûüūůűŭũųÙÚÛÜŪŮŰŬŨŲ]/, 'u')
    permalink.gsub!(/ŵŴ/, 'w')
    permalink.gsub!(/[ýÿŷÝŸŶ]/, 'y')
    permalink.gsub!(/[žżźŽŻŹ]/, 'z')
    permalink
  end
end
