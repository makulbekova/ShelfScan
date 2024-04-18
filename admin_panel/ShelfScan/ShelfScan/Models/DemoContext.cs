using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace ShelfScan.Models;

public partial class DemoContext : DbContext
{
    public DemoContext()
    {
    }

    public DemoContext(DbContextOptions<DemoContext> options)
        : base(options)
    {
    }

    public virtual DbSet<ApiEmployee> ApiEmployees { get; set; }

    public virtual DbSet<ApiLocation> ApiLocations { get; set; }

    public virtual DbSet<ApiPhoto> ApiPhotos { get; set; }

    public virtual DbSet<ApiPlanogram> ApiPlanograms { get; set; }

    public virtual DbSet<ApiPrice> ApiPrices { get; set; }

    public virtual DbSet<ApiProduct> ApiProducts { get; set; }

    public virtual DbSet<ApiRemark> ApiRemarks { get; set; }

    public virtual DbSet<ApiRole> ApiRoles { get; set; }

    public virtual DbSet<ApiScan> ApiScans { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseNpgsql("Host=localhost;Port=5433;Database=shelf_scan_db;Username=postgres;Password=123");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ApiEmployee>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("api_employee_pkey");

            entity.HasOne(d => d.Role).WithMany(p => p.ApiEmployees)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("api_employee_role_id_f7c7c850_fk_api_role_id");
        });

        modelBuilder.Entity<ApiLocation>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("api_location_pkey");
        });

        modelBuilder.Entity<ApiPhoto>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("api_photo_pkey");
        });

        modelBuilder.Entity<ApiPlanogram>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("api_planogram_pkey");

            entity.HasOne(d => d.Location).WithMany(p => p.ApiPlanograms)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("api_planogram_location_id_e9b869d4_fk_api_location_id");
        });

        modelBuilder.Entity<ApiPrice>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("api_price_pkey");

            entity.HasOne(d => d.Product).WithMany(p => p.ApiPrices)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("api_price_product_id_ee17657e_fk_api_product_id");
        });

        modelBuilder.Entity<ApiProduct>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("api_product_pkey");

            entity.HasOne(d => d.Scan).WithMany(p => p.ApiProducts)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("api_product_scan_id_1a022165_fk_api_scan_id");
        });

        modelBuilder.Entity<ApiRemark>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("api_remark_pkey");

            entity.HasOne(d => d.Scan).WithMany(p => p.ApiRemarks)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("api_remark_scan_id_38f9984d_fk_api_scan_id");
        });

        modelBuilder.Entity<ApiRole>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("api_role_pkey");
        });

        modelBuilder.Entity<ApiScan>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("api_scan_pkey");

            entity.HasOne(d => d.Employee).WithMany(p => p.ApiScans)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("api_scan_employee_id_f262cebe_fk_api_employee_id");

            entity.HasOne(d => d.Location).WithMany(p => p.ApiScans)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("api_scan_location_id_32a4bd8e_fk_api_location_id");

            entity.HasOne(d => d.Photo).WithMany(p => p.ApiScans)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("api_scan_photo_id_aa56c3a4_fk_api_photo_id");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
