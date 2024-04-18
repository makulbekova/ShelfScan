using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ShelfScan.Models;

[Table("api_photo")]
public partial class ApiPhoto
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Column("photo_path")]
    [StringLength(255)]
    public string PhotoPath { get; set; } = null!;

    [InverseProperty("Photo")]
    public virtual ICollection<ApiScan> ApiScans { get; set; } = new List<ApiScan>();
}
