# -----------
# Figures Created Based on Estimates in UKB
# Forest Plots and Estimate Comparisons
# -----------

# Loading in package for forest plot (ubiquitous in MR Lit - tho often no pooling)
#install.packages('meta')
#library(meta)

# CAN use meta but this is really for meta-analytical pooling of results... Can do simply in ggplot


# Source: https://www.statology.org/forest-plot-in-r/


# FIRST creating a forest plot to COMPARE observational estimates for different strata

obs <- data.frame(study=c('Pooled (n = 256,920)', 'No High School Education (n = 38,667)', 'At Least High School Education (n = 218,315)', 'No University Degree (n = 170,366)', 'At Least a University Degree (n = 86,616)'),
                 index=1:5,
                 effect=c(4.83, 7.17, 4.29, 4.86, 4.15),
                 lower=c(4.57, 6.21, 4.02, 4.53, 3.72),
                 upper=c(5.09, 8.13, 4.56, 5.19, 4.58))




library(ggplot2)

#create forest plot
ggplot(data=obs, aes(y=index, x=effect, xmin=lower, xmax=upper)) +
            geom_point() + 
            geom_errorbarh(height=.1) +
            scale_y_continuous(breaks=1:nrow(obs), labels=obs$study) +
            labs(title='Effect Size by Socioeconomic Stratum', subtitle = 'Observational Model', x='Effect Size (per 10,000 people per year)', y = 'Educational Attainment') +
            geom_vline(xintercept=0, color='black', linetype='dashed', alpha=.5) + theme_classic()



# Save high res plot - a tiff file basically lets you save ultra high quality figures you can share/save as pdf
dev.off
ggsave("ObsMod.png",units="in",width = 6, height = 4, dpi = 1200, device = 'png')
options(repr.plot.width = 0.5, repr.plot.height = 0.5)









# NOW creating a forest plot to COMPARE IVW estimates for different strata

ivw <- data.frame(study=c('Pooled (n = 256,920)', 'No High School Education (n = 38,667)', 'At Least High School Education (n = 218,315)', 'No University Degree (n = 170,366)', 'At Least a University Degree (n = 86,616)'),
                  index=1:5,
                  effect=c(5.67, 6.35, 5.27, 6.52, 2.75),
                  lower=c(3.59, -0.01, 3.25, 3.92, -0.01),
                  upper=c(7.74, 12.70, 7.30, 9.13, 5.62))




library(ggplot2)

#create forest plot
ggplot(data=ivw, aes(y=index, x=effect, xmin=lower, xmax=upper)) +
  geom_point() + 
  geom_errorbarh(height=.1) +
  scale_y_continuous(breaks=1:nrow(ivw), labels=ivw$study) +
  labs(title='Effect Size by Socioeconomic Stratum', subtitle = 'IVW Model', x='Effect Size (per 10,000 people per year)', y = 'Educational Attainment') +
  geom_vline(xintercept=0, color='black', linetype='dashed', alpha=.5) + theme_classic()



# Save high res plot - a tiff file basically lets you save ultra high quality figures you can share/save as pdf
dev.off
ggsave("IVWMod.png",units="in",width = 6, height = 4, dpi = 1200, device = 'png')
options(repr.plot.width = 0.5, repr.plot.height = 0.5)






# NOW creating a forest plot to COMPARE Weighted Median estimates for different strata

med <- data.frame(study=c('Pooled (n = 256,920)', 'No High School Education (n = 38,667)', 'At Least High School Education (n = 218,315)', 'No University Degree (n = 170,366)', 'At Least a University Degree (n = 86,616)'),
                  index=1:5,
                  effect=c(4.21, 3.45, 4.53, 4.53, 2.59),
                  lower=c(1.35, -0.01, 1.47, 1.17, -1.77),
                  upper=c(7.07, 12.10, 7.59, 7.90, 6.96))




library(ggplot2)

#create forest plot
ggplot(data=med, aes(y=index, x=effect, xmin=lower, xmax=upper)) +
  geom_point() + 
  geom_errorbarh(height=.1) +
  scale_y_continuous(breaks=1:nrow(med), labels=med$study) +
  labs(title='Effect Size by Socioeconomic Stratum', subtitle = 'Weighted Median Model', x='Effect Size (per 10,000 people per year)', y = 'Educational Attainment') +
  geom_vline(xintercept=0, color='black', linetype='dashed', alpha=.5) + theme_classic()



# Save high res plot - a tiff file basically lets you save ultra high quality figures you can share/save as pdf
dev.off
ggsave("MedMod.png",units="in",width = 6, height = 4, dpi = 1200, device = 'png')
options(repr.plot.width = 0.5, repr.plot.height = 0.5)
