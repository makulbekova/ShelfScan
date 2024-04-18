using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ShelfScan.Models;

[Table("api_price")]
[Index("ProductId", Name = "api_price_product_id_ee17657e")]
public partial class ApiPrice
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Column("price")]
    public double Price { get; set; }

    [Column("is_special_offer")]
    public bool IsSpecialOffer { get; set; }

    [Column("date_price")]
    public DateOnly DatePrice { get; set; }

    [Column("product_id")]
    public long ProductId { get; set; }

    [ForeignKey("ProductId")]
    [InverseProperty("ApiPrices")]
    public virtual ApiProduct Product { get; set; } = null!;
}
