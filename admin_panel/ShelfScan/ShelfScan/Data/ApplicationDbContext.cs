using Microsoft.EntityFrameworkCore;
using ShelfScan.Models;

namespace ShelfScan.Data
{
    public class ApplicationDbContext : DbContext
    {
        protected readonly IConfiguration Configuration;

        public ApplicationDbContext(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            // connect to postgres with connection string from app settings
            options.UseNpgsql(Configuration.GetConnectionString("WebApiDatabase"));
        }
        public DbSet<ApiCity> ApiCities { get; set; }

        public DbSet<ApiEmployee> ApiEmployees { get; set; }

        public DbSet<ApiLocation> ApiLocations { get; set; }

        public DbSet<ApiPhoto> ApiPhotos { get; set; }

        public DbSet<ApiPlanogram> ApiPlanograms { get; set; }

        public DbSet<ApiPrice> ApiPrices { get; set; }

        public DbSet<ApiProduct> ApiProducts { get; set; }

        public DbSet<ApiRemark> ApiRemarks { get; set; }

        public DbSet<ApiRole> ApiRoles { get; set; }

        public DbSet<ApiScan> ApiScans { get; set; }
    }
}
