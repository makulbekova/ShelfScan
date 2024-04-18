using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
using Microsoft.EntityFrameworkCore;

namespace ShelfScan.Models;

[Table("api_employee")]
[Index("RoleId", Name = "api_employee_role_id_f7c7c850")]
public partial class ApiEmployee
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Column("first_name")]
    [StringLength(255)]
    public string FirstName { get; set; } = null!;

    [Column("last_name")]
    [StringLength(255)]
    public string LastName { get; set; } = null!;

    [Column("phone")]
    [StringLength(255)]
    public string Phone { get; set; } = null!;

    [Column("hashed_password")]
    [StringLength(255)]
    public string HashedPassword { get; set; } = null!;

    [Column("role_id")]
    public long RoleId { get; set; }

    [InverseProperty("Employee")]
    public virtual ICollection<ApiScan> ApiScans { get; set; } = new List<ApiScan>();

    [ForeignKey("RoleId")]
    [InverseProperty("ApiEmployees")]
    [JsonIgnore]
    public virtual ApiRole Role { get; set; } = null!;



}
