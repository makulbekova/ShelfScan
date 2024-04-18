using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ShelfScan.Models;

[Table("api_product")]
[Index("ScanId", Name = "api_product_scan_id_1a022165")]
public partial class ApiProduct
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Column("name")]
    [StringLength(255)]
    public string Name { get; set; } = null!;

    [Column("sku")]
    [StringLength(255)]
    public string Sku { get; set; } = null!;

    [Column("scan_id")]
    public long ScanId { get; set; }

    [InverseProperty("Product")]
    public virtual ICollection<ApiPrice> ApiPrices { get; set; } = new List<ApiPrice>();

    [ForeignKey("ScanId")]
    [InverseProperty("ApiProducts")]
    public virtual ApiScan Scan { get; set; } = null!;
}
