using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ShelfScan.Models;

[Table("api_planogram")]
[Index("LocationId", Name = "api_planogram_location_id_e9b869d4")]
public partial class ApiPlanogram
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Column("photo_path")]
    [StringLength(255)]
    public string PhotoPath { get; set; } = null!;

    [Column("name")]
    [StringLength(255)]
    public string Name { get; set; } = null!;

    [Column("description")]
    public string Description { get; set; } = null!;

    [Column("location_id")]
    public long LocationId { get; set; }

    [ForeignKey("LocationId")]
    [InverseProperty("ApiPlanograms")]
    public virtual ApiLocation Location { get; set; } = null!;
}
