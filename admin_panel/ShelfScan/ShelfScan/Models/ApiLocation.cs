using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
using Microsoft.EntityFrameworkCore;

namespace ShelfScan.Models;

[Table("api_location")]
[Index("CityId", Name = "api_location_city_id_7ff1f151")]
public partial class ApiLocation
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Column("name")]
    [StringLength(255)]
    public string Name { get; set; } = null!;

    [Column("address")]
    [StringLength(255)]
    public string Address { get; set; } = null!;

    [Column("city_id")]
    public long CityId { get; set; }

    [ForeignKey("CityId")]
    [InverseProperty("ApiLocations")]
    [JsonIgnore]
    public virtual ApiCity City { get; set; } = null!;

    [InverseProperty("Location")]
    public virtual ICollection<ApiPlanogram> ApiPlanograms { get; set; } = new List<ApiPlanogram>();

    [InverseProperty("Location")]
    public virtual ICollection<ApiScan> ApiScans { get; set; } = new List<ApiScan>();
}
